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

module "vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork//?ref=master"

  name = "Test1VPC"
}

resource "aws_security_group" "es_security_group" {
  name   = "ES-VPC-SG"
  vpc_id = module.vpc.vpc_id
}

module "es_vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=master"

  name            = "es-vpc-endpoint"
  security_groups = [aws_security_group.es_security_group.id]
  subnets         = module.vpc.private_subnets
  vpc_enabled     = true
}
