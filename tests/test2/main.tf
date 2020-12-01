terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 3.0"
  region  = "us-west-1"
}

resource "random_string" "r_string" {
  length  = 6
  lower   = true
  number  = false
  special = false
  upper   = false
}

module "vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork//?ref=master"

  az_count = 2
  name     = "ES-VPC-${random_string.r_string.result}"
}

module "sg" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-security_group?ref=master"

  name   = "ES-VPC-SG-${random_string.r_string.result}"
  vpc_id = module.vpc.vpc_id
}

####################################################
# Basic VPC 3 AZ accessible Elasticsearch endpoint #
####################################################

module "es_vpc" {
  source = "../../module"

  name            = "es-vpc-endpoint-${random_string.r_string.result}"
  security_groups = [module.sg.public_web_security_group_id]
  subnets         = module.vpc.private_subnets
  vpc_enabled     = true
}

#############################################
# Customized VPC 3AZ Elasticsearch endpoint #
#############################################

data "aws_kms_alias" "es_kms" {
  name = "alias/aws/es"
}

module "internal_zone" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-route53_internal_zone?ref=master"

  environment = "Development"
  name        = "mycompany-${random_string.r_string.result}.local"
  vpc_id      = module.vpc.vpc_id
}

module "es_all_options" {
  source = "../../module"

  data_node_count            = 6
  data_node_instance_type    = "m5.large.elasticsearch"
  ebs_iops                   = 1000
  ebs_size                   = 35
  ebs_type                   = "io1"
  elasticsearch_version      = "7.1"
  encrypt_storage_enabled    = true
  encrypt_traffic_enabled    = true
  encryption_kms_key         = data.aws_kms_alias.es_kms.target_key_arn
  environment                = "Development"
  internal_record_name       = "es-custom"
  internal_zone_id           = module.internal_zone.internal_hosted_zone_id
  internal_zone_name         = module.internal_zone.internal_hosted_name
  ip_whitelist               = ["1.2.3.4"]
  logging_application_logs   = true
  logging_index_slow_logs    = true
  logging_retention          = 7
  logging_search_slow_logs   = true
  master_node_count          = 3
  master_node_instance_type  = "m5.large.elasticsearch"
  name                       = "es-custom3az-${random_string.r_string.result}"
  subnets                    = module.vpc.private_subnets

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}
