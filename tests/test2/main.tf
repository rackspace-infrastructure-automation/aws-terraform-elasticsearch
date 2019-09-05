provider "aws" {
  version = "~> 2.2"
  region  = "us-west-2"
}

resource "random_string" "r_string" {
  length  = 6
  special = false
  lower   = true
  upper   = false
  number  = false
}

module "vpc" {
  source   = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork?ref=master"
  az_count = "3"
  vpc_name = "ES-VPC-${random_string.r_string.result}"
}

module "sg" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-security_group?ref=master"

  resource_name = "ES-VPC-SG-${random_string.r_string.result}"
  vpc_id        = "${module.vpc.vpc_id}"
}

####################################################
# Basic VPC 3 AZ accessible Elasticsearch endpoint #
####################################################

module "es_vpc" {
  source = "../../module"

  name = "es-vpc-endpoint-${random_string.r_string.result}"

  vpc_enabled     = true
  security_groups = ["${module.sg.public_web_security_group_id}"]
  subnets         = ["${module.vpc.private_subnets}"]
}

#############################################
# Customized VPC 3AZ Elasticsearch endpoint #
#############################################

data "aws_kms_alias" "es_kms" {
  name = "alias/aws/es"
}

module "internal_zone" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-route53_internal_zone?ref=master"

  zone_name     = "mycompany-${random_string.r_string.result}.local"
  environment   = "Development"
  target_vpc_id = "${module.vpc.vpc_id}"
}

module "es_all_options" {
  source = "../../module"

  name = "es-custom3az-${random_string.r_string.result}"

  ip_whitelist = ["1.2.3.4"]

  elasticsearch_version = "7.1"
  environment           = "Development"
  subnets               = ["${module.vpc.private_subnets}"]

  data_node_count           = "6"
  data_node_instance_type   = "m5.large.elasticsearch"
  master_node_count         = "3"
  master_node_instance_type = "m5.large.elasticsearch"

  encrypt_storage_enabled = true
  encrypt_traffic_enabled = true
  encryption_kms_key      = "${data.aws_kms_alias.es_kms.target_key_arn}"

  ebs_iops = "1000"
  ebs_size = "35"
  ebs_type = "io1"

  internal_record_name = "es-custom"
  internal_zone_id     = "${module.internal_zone.internal_hosted_zone_id}"
  internal_zone_name   = "${module.internal_zone.internal_hosted_name}"

  logging_application_logs = true
  logging_index_slow_logs  = true
  logging_retention        = 7
  logging_search_slow_logs = true

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}
