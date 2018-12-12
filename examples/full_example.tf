#########################################################
# Customized Internet accessible Elasticsearch endpoint #
#########################################################

data "aws_kms_alias" "es_kms" {
  name = "alias/aws/es"
}

module "internal_zone" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-route53_internal_zone//?ref=v.0.0.1"

  zone_name     = "mycompany.local"
  environment   = "Development"
  target_vpc_id = "${module.vpc.vpc_id}"
}

module "es_all_options" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.0.2"

  name = "es-custom"

  ip_whitelist = ["1.2.3.4"]

  elasticsearch_version = "6.2"
  environment           = "Production"

  data_node_count           = "8"
  data_node_instance_type   = "r4.large.elasticsearch"
  master_node_count         = "5"
  master_node_instance_type = "r4.large.elasticsearch"

  encryption_enabled = true
  encryption_kms_key = "${data.aws_kms_alias.es_kms.target_key_arn}"

  ebs_iops = "1000"
  ebs_size = "50"
  ebs_type = "io1"

  internal_record_name = "es-custom"
  internal_zone_name   = "${module.internal_zone.internal_hosted_name}"

  logging_application_logs = true
  logging_index_slow_logs  = true
  logging_retention        = 14
  logging_search_slow_logs = true

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}