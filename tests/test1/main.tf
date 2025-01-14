terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}


provider "aws" {
  region = "us-west-2"
}

resource "random_string" "r_string" {
  length  = 6
  lower   = true
  numeric = false
  special = false
  upper   = false
}

module "vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork//?ref=master"

  az_count = 2
  name     = "ES-VPC-${random_string.r_string.result}"
}

resource "aws_security_group" "es_security_group" {
  name   = "ES-VPC-SG-${random_string.r_string.result}"
  vpc_id = module.vpc.vpc_id
}

####################################################
# Basic VPC 3 AZ accessible Elasticsearch endpoint #
####################################################

module "es_vpc" {
  source = "../../module"

  name            = "es-vpc-endpoint-${random_string.r_string.result}"
  security_groups = [aws_security_group.es_security_group.id]
  subnets         = module.vpc.private_subnets
  vpc_enabled     = true
}

#############################################
# Customized VPC 3AZ Elasticsearch endpoint #
#############################################

resource "aws_route53_zone" "internal_zone" {
  name = "mycompany-${random_string.r_string.result}.local"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

module "es_all_options" {
  source = "../../module"

  data_node_count           = 6
  data_node_instance_type   = "t2.small.elasticsearch"
  ebs_size                  = 20
  ebs_type                  = "gp2"
  elasticsearch_version     = "7.10"
  encrypt_storage_enabled   = false
  encrypt_traffic_enabled   = true
  environment               = "Development"
  internal_record_name      = "es-custom"
  internal_zone_id          = aws_route53_zone.internal_zone.zone_id
  internal_zone_name        = aws_route53_zone.internal_zone.name
  ip_whitelist              = ["1.2.3.4"]
  logging_application_logs  = true
  logging_index_slow_logs   = true
  logging_retention         = 7
  logging_search_slow_logs  = true
  master_node_count         = 3
  master_node_instance_type = "t2.small.elasticsearch"
  name                      = "es-custom3azv13-${random_string.r_string.result}"
  subnets                   = module.vpc.private_subnets

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}
