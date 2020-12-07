terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.2"
  region  = "us-west-2"
}

resource "random_string" "r_string" {
  length  = 6
  lower   = true
  number  = false
  special = false
  upper   = false
}

####################################################
# Basic Internet accessible Elasticsearch endpoint #
####################################################

module "es_internet" {
  source = "../../module"

  ip_whitelist = ["1.2.3.4"]
  name         = "es-internet-endpointv13-${random_string.r_string.result}"
}
