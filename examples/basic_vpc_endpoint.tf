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
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork//?ref=v0.12.2"

  name = "Test1VPC"
}

module "sg" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-security_group//?ref=v0.12.0"

  resource_name = "Test-SG"
  vpc_id        = module.vpc.vpc_id
}

module "es_vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.13.1"

  name            = "es-vpc-endpoint"
  security_groups = [module.sg.public_web_security_group_id]
  subnets         = module.vpc.private_subnets
  vpc_enabled     = true
}
