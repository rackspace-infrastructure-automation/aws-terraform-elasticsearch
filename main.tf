/**
 * # aws-terraform-elasticsearch
 *
 *This module creates an ElasticSearch cluster.
 *
 *
 *## Basic Usage
 *
 ### Internet accessible endpoint
 *```
 *module "elasticsearch" {
 *  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.0.1"
 *
 *  name          = "titus-test-es-internet-endpoint"
 *  ip_whitelist  = ["1.2.3.4"]
 *}
 *```
 *
 ### VPC accessible endpoint
 *```
 *module "elasticsearch" {
 *  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.0.1"
 *
 *  name          = "titus-test-es-internet-endpoint"
 *  vpc_enabled     = true
 *  security_groups = ["${module.sg.public_web_security_group_id}"]
 *  subnets         = ["${module.vpc.private_subnets}"]
 *}
 *```
 *
 * Full working references are available at [examples](examples)
 */

locals {
  tags {
    Name            = "${var.name}"
    ServiceProvider = "Rackspace"
    Environment     = "${var.environment}"
  }

  policy_condition = {
    standard = [
      {
        test     = "IpAddress"
        variable = "aws:SourceIp"
        values   = ["${var.ip_whitelist}"]
      },
    ]

    vpc = []
  }

  vpc_configuration = {
    standard = []

    vpc = [
      {
        security_group_ids = ["${var.security_groups}"]
        subnet_ids         = ["${var.subnets}"]
      },
    ]
  }

  vpc_lookup     = "${var.vpc_enabled ? "vpc" : "standard"}"
  enable_logging = "${var.logging_application_logs || var.logging_index_slow_logs || var.logging_search_slow_logs}"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "policy" {
  statement {
    actions   = ["es:*"]
    effect    = "Allow"
    resources = ["arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.name}/*"]

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    condition = "${local.policy_condition[local.vpc_lookup]}"
  }
}

resource "aws_cloudwatch_log_group" "es" {
  count = "${local.enable_logging ? 1 : 0}"

  name_prefix       = "${var.name}"
  retention_in_days = "${var.logging_retention}"
  tags              = "${merge(var.tags, local.tags)}"
}

data "aws_iam_policy_document" "es_cloudwatch_policy" {
  count = "${local.enable_logging ? 1 : 0}"

  statement {
    actions   = ["logs:PutLogEvents", "logs:CreateLogStream"]
    effect    = "Allow"
    resources = ["${element(concat(aws_cloudwatch_log_group.es.*.arn, list("*")), 0)}"]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "es_cloudwatch_policy" {
  count = "${local.enable_logging ? 1 : 0}"

  policy_document = "${element(data.aws_iam_policy_document.es_cloudwatch_policy.*.json, 0)}"
  policy_name     = "Elasticsearch-Log-Access"
}

resource "aws_elasticsearch_domain" "es" {
  access_policies = "${data.aws_iam_policy_document.policy.json}"

  advanced_options = [{
    "rest.action.multi.allow_explicit_index" = "true"
  }]

  domain_name           = "${lower(var.name)}"
  elasticsearch_version = "${var.elasticsearch_version}"

  snapshot_options = {
    automated_snapshot_start_hour = "${var.snapshot_start_hour}"
  }

  tags        = "${merge(var.tags, local.tags)}"
  vpc_options = ["${local.vpc_configuration[local.vpc_lookup]}"]

  cluster_config {
    dedicated_master_count   = "${var.master_node_count > 0 ? var.master_node_count : 0 }"
    dedicated_master_enabled = "${var.master_node_count > 0}"
    dedicated_master_type    = "${var.master_node_count > 0 ? var.master_node_instance_type : "" }"
    instance_count           = "${var.data_node_count}"
    instance_type            = "${var.data_node_instance_type}"
    zone_awareness_enabled   = true
  }

  ebs_options {
    ebs_enabled = true
    iops        = "${lower(var.ebs_type) == "io1" ? var.ebs_iops : 0}"
    volume_size = "${var.ebs_size}"
    volume_type = "${lower(var.ebs_type)}"
  }

  encrypt_at_rest {
    enabled    = "${var.encryption_enabled}"
    kms_key_id = "${var.encryption_kms_key}"
  }

  log_publishing_options = [
    {
      log_type                 = "INDEX_SLOW_LOGS"
      cloudwatch_log_group_arn = "${element(concat(aws_cloudwatch_log_group.es.*.arn, list("")), 0)}"
      enabled                  = "${var.logging_index_slow_logs}"
    },
    {
      log_type                 = "SEARCH_SLOW_LOGS"
      cloudwatch_log_group_arn = "${element(concat(aws_cloudwatch_log_group.es.*.arn, list("")), 0)}"
      enabled                  = "${var.logging_search_slow_logs}"
    },
    {
      log_type                 = "ES_APPLICATION_LOGS"
      cloudwatch_log_group_arn = "${element(concat(aws_cloudwatch_log_group.es.*.arn, list("")), 0)}"
      enabled                  = "${var.logging_application_logs}"
    },
  ]
}

data "aws_route53_zone" "hosted_zone" {
  count = "${var.internal_record_name != "" ? 1 : 0}"

  name         = "${var.internal_zone_name}"
  private_zone = true
}

resource "aws_route53_record" "zone_record_alias" {
  count = "${var.internal_record_name != "" ? 1 : 0}"

  name    = "${var.internal_record_name}.${data.aws_route53_zone.hosted_zone.name}"
  records = ["${aws_elasticsearch_domain.es.endpoint}"]
  ttl     = "300"
  type    = "CNAME"
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"
}