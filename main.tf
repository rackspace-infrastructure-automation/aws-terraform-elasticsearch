/**
 * # aws-terraform-elasticsearch
 *
 * This module creates an ElasticSearch cluster.
 *
 * ## Basic Usage
 *
 * ### Internet accessible endpoint
 *
 * ```HCL
 * module "elasticsearch" {
 *   source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.12.3"
 *
 *   name          = "es-internet-endpoint"
 *   ip_whitelist  = ["1.2.3.4"]
 * }
 * ```
 *
 * ### VPC accessible endpoint
 *
 * ```HCL
 * module "elasticsearch" {
 *   source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.12.3"
 *
 *   name            = "es-vpc-endpoint"
 *   vpc_enabled     = true
 *   security_groups = [module.sg.public_web_security_group_id]
 *   subnets         = [module.vpc.private_subnets]
 * }
 * ```
 *
 * Full working references are available at [examples](examples)
 *
 * ## Limitation
 *
 * Terraform does not create the IAM Service Linked Role for ElasticSearch automatically.  If this role is not present on an account, the `create_service_linked_role` parameter should be set to true for the first ElasticSearch instance.  This will create the required role.  This option should not be set to true on more than a single deployment per account, or it will result in a naming conflict.  If the role is not present an error similar to the following would result:
 * Error creating ElasticSearch domain: ValidationException: Before you can proceed, you must enable a service-linked role to give Amazon ES permissions to access your VPC.
 * ```
 * 1 error(s) occurred:
 *
 * * module.elasticsearch.aws_elasticsearch_domain.es: 1 error(s) occurred:
 *
 * * aws_elasticsearch_domain.es: Error reading IAM Role AWSServiceRoleForAmazonElasticsearchService: NoSuchEntity: The role with name AWSServiceRoleForAmazonElasticsearchService cannot be found.
 *     status code: 404, request id: 5a1614d2-1e64-11e9-a87e-3149d48d2026
 * ```
 */

terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = ">= 2.2.0"
  }
}

locals {
  vpc_lookup      = var.vpc_enabled ? "vpc" : "standard"
  enable_logging  = var.logging_application_logs || var.logging_index_slow_logs || var.logging_search_slow_logs
  za_subnet_count = length(var.subnets) >= 3 ? 3 : 2

  tags = {
    Environment     = var.environment
    Name            = var.name
    ServiceProvider = "Rackspace"
  }

  policy_condition = {
    standard = [{
      test     = "IpAddress"
      values   = var.ip_whitelist
      variable = "aws:SourceIp"
    }]
    vpc = []
  }

  vpc_configuration = {
    standard = []
    vpc = [
      {
        security_group_ids = var.security_groups
        subnet_ids         = var.subnets
      },
    ]
  }
}

data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "policy" {

  statement {
    actions   = ["es:*"]
    effect    = "Allow"
    resources = ["arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.name}/*"]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    dynamic "condition" {
      for_each = local.policy_condition[local.vpc_lookup]
      content {
        test     = condition.value.test
        values   = condition.value.values
        variable = condition.value.variable
      }
    }
  }
}

resource "aws_iam_service_linked_role" "slr" {
  count = var.create_service_linked_role ? 1 : 0

  aws_service_name = "es.amazonaws.com"
}

resource "aws_cloudwatch_log_group" "es" {
  count = local.enable_logging ? 1 : 0

  name_prefix       = var.name
  retention_in_days = var.logging_retention
  tags              = merge(var.tags, local.tags)
}

data "aws_iam_policy_document" "es_cloudwatch_policy" {
  count = local.enable_logging ? 1 : 0

  statement {
    actions   = ["logs:PutLogEvents", "logs:CreateLogStream"]
    effect    = "Allow"
    resources = [element(concat(aws_cloudwatch_log_group.es.*.arn, ["*"]), 0)]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "es_cloudwatch_policy" {
  count = local.enable_logging ? 1 : 0

  policy_document = element(data.aws_iam_policy_document.es_cloudwatch_policy.*.json, 0)
  policy_name     = "Elasticsearch-Log-Access"
}

resource "aws_elasticsearch_domain" "es" {
  access_policies       = var.custom_access_policy ? var.custom_access_policy : data.aws_iam_policy_document.policy.json
  domain_name           = lower(var.name)
  elasticsearch_version = var.elasticsearch_version
  tags                  = merge(var.tags, local.tags)

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true",
    "indices.query.bool.max_clause_count"    = var.max_clause_count
  }

  cluster_config {
    dedicated_master_count   = var.master_node_count > 0 ? var.master_node_count : 0
    dedicated_master_enabled = var.master_node_count > 0
    dedicated_master_type    = var.master_node_count > 0 ? var.master_node_instance_type : ""
    instance_count           = var.data_node_count
    instance_type            = var.data_node_instance_type
    zone_awareness_enabled   = var.zone_awareness_enabled

    zone_awareness_config {
      availability_zone_count = var.zone_awareness_enabled == "false" ? 2 : local.za_subnet_count
    }
  }

  ebs_options {
    ebs_enabled = true
    iops        = lower(var.ebs_type) == "io1" ? var.ebs_iops : 0
    volume_size = var.ebs_size
    volume_type = lower(var.ebs_type)
  }

  encrypt_at_rest {
    enabled    = var.encrypt_storage_enabled
    kms_key_id = var.encryption_kms_key
  }

  log_publishing_options {
    log_type                 = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = element(concat(aws_cloudwatch_log_group.es.*.arn, [""]), 0)
    enabled                  = var.logging_index_slow_logs
  }

  log_publishing_options {
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = element(concat(aws_cloudwatch_log_group.es.*.arn, [""]), 0)
    enabled                  = var.logging_search_slow_logs
  }

  log_publishing_options {
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = element(concat(aws_cloudwatch_log_group.es.*.arn, [""]), 0)
    enabled                  = var.logging_application_logs
  }

  node_to_node_encryption {
    enabled = var.encrypt_traffic_enabled
  }

  snapshot_options {
    automated_snapshot_start_hour = var.snapshot_start_hour
  }

  dynamic "vpc_options" {
    for_each = local.vpc_configuration[local.vpc_lookup]
    content {
      security_group_ids = lookup(vpc_options.value, "security_group_ids", null)
      subnet_ids         = lookup(vpc_options.value, "subnet_ids", null)
    }
  }

  depends_on = [aws_iam_service_linked_role.slr]
}

resource "aws_route53_record" "zone_record_alias" {
  count = var.internal_record_name != "" ? 1 : 0

  name    = "${var.internal_record_name}.${var.internal_zone_name}"
  records = [aws_elasticsearch_domain.es.endpoint]
  ttl     = "300"
  type    = "CNAME"
  zone_id = var.internal_zone_id
}
