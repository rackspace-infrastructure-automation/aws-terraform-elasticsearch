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

module "es_internet" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.13.1"

  ip_whitelist = ["1.2.3.4"]
  name         = "es-internet-endpoint"
}
