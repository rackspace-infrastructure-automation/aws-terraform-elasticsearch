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

data "aws_kms_alias" "es_kms" {
  name = "alias/aws/es"
}

resource "aws_route53_zone" "internal_zone" {
  name = "mycompany.local"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

module "es_all_options" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=master"

  data_node_count           = 6
  data_node_instance_type   = "t2.small.elasticsearch"
  ebs_iops                  = 1000
  ebs_size                  = 50
  ebs_type                  = "io1"
  elasticsearch_version     = "7.10"
  encrypt_storage_enabled   = true
  encrypt_traffic_enabled   = true
  encryption_kms_key        = data.aws_kms_alias.es_kms.target_key_arn
  environment               = "Production"
  internal_record_name      = "es-custom"
  internal_zone_id          = module.internal_zone.internal_hosted_name
  internal_zone_name        = module.internal_zone.internal_hosted_name
  ip_whitelist              = ["1.2.3.4"]
  logging_application_logs  = true
  logging_index_slow_logs   = true
  logging_retention         = 14
  logging_search_slow_logs  = true
  master_node_count         = 3
  master_node_instance_type = "t2.small.elasticsearch"
  max_clause_count          = "2048"
  name                      = "es-custom"
  security_groups           = ["sg-0024aee5bbfbaddbc", "sg-018f1576271f11f3e"]
  snapshot_start_hour       = 21
  subnets                   = ["subnet-0146733139bfe351b", "subnet-04362ec0a2a4b1382"]
  vpc_enabled               = true

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }
}
