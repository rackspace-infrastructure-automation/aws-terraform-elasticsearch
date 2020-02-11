terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.2"
  region  = "us-west-2"
}

module "es_internet" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.0.7"

  name         = "es-internet-endpoint"
  ip_whitelist = ["1.2.3.4"]
}
