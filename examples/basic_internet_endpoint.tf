####################################################
# Basic Internet accessible Elasticsearch endpoint #
####################################################

module "es_internet" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.0.8"

  ip_whitelist = ["1.2.3.4"]
  name         = "es-internet-endpoint"
}
