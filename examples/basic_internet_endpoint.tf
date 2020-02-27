terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region  = "us-west-2"
  version = "~> 2.2"
}

module "es_internet" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.12.1"

  ip_whitelist = ["1.2.3.4"]
  name         = "es-internet-endpoint"
}
