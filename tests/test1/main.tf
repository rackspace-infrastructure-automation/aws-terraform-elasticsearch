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

####################################################
# Basic Internet accessible Elasticsearch endpoint #
####################################################

module "es_internet" {
  source = "../../module"

  ip_whitelist = ["1.2.3.4"]
  name         = "es-internet-endpoint-${random_string.r_string.result}"
}
