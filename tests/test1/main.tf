terraform {
  required_version = ">= 0.12"
}

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

####################################################
# Basic Internet accessible Elasticsearch endpoint #
####################################################

module "es_internet" {
  source = "../../module"

  name         = "es-internet-endpoint-${random_string.r_string.result}"
  ip_whitelist = ["1.2.3.4"]
}
