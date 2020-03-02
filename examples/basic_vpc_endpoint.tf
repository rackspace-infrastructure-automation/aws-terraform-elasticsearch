###############################################
# Basic VPC accessible Elasticsearch endpoint #
###############################################

module "vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork//?ref=v0.0.10"

  vpc_name = "Test1VPC"
}

module "sg" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-security_group//?ref=v0.0.6"

  resource_name = "Test-SG"
  vpc_id        = "${module.vpc.vpc_id}"
}

module "es_vpc" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.0.8"

  name = "es-vpc-endpoint"

  vpc_enabled     = true
  security_groups = ["${module.sg.public_web_security_group_id}"]
  subnets         = ["${module.vpc.private_subnets}"]
}
