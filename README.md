# aws-terraform-elasticsearch

This module creates an ElasticSearch cluster.

## Basic Usage

### Internet accessible endpoint

```HCL
module "elasticsearch" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.0.8"

  name          = "es-internet-endpoint"
  ip_whitelist  = ["1.2.3.4"]
}
```

### VPC accessible endpoint

```HCL
module "elasticsearch" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.0.8"

  name            = "es-vpc-endpoint"
  vpc_enabled     = true
  security_groups = ["${module.sg.public_web_security_group_id}"]
  subnets         = ["${module.vpc.private_subnets}"]
}
```

Full working references are available at [examples](examples)

## Limitation

Terraform does not create the IAM Service Linked Role for ElasticSearch automatically.  If this role is not present on an account, the `create_service_linked_role` parameter should be set to true for the first ElasticSearch instance.  This will create the required role.  This option should not be set to true on more than a single deployment per account, or it will result in a naming conflict.  If the role is not present an error similar to the following would result:

```
1 error(s) occurred:

* module.elasticsearch.aws_elasticsearch_domain.es: 1 error(s) occurred:

* aws_elasticsearch_domain.es: Error reading IAM Role AWSServiceRoleForAmazonElasticsearchService: NoSuchEntity: The role with name AWSServiceRoleForAmazonElasticsearchService cannot be found.
    status code: 404, request id: 5a1614d2-1e64-11e9-a87e-3149d48d2026
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) |
| [aws_cloudwatch_log_resource_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) |
| [aws_elasticsearch_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_service_linked_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_service\_linked\_role | A boolean value to determine if the ElasticSearch Service Linked Role should be created.  This should only be set to true if the Service Linked Role is not already present. | `string` | `false` | no |
| data\_node\_count | Number of data nodes in the Elasticsearch cluster. If using Zone Awareness this must be a multiple of the number of subnets being used, e.g. 2, 4, 6, etc. for 2 subnets or 3, 6, 9, etc. for 3 subnets. | `string` | `6` | no |
| data\_node\_instance\_type | Select data node instance type.  See https://aws.amazon.com/elasticsearch-service/pricing/ for supported instance types. | `string` | `"m5.large.elasticsearch"` | no |
| ebs\_iops | The number of I/O operations per second (IOPS) that the volume supports. | `string` | `0` | no |
| ebs\_size | The size of the EBS volume for each data node. | `string` | `35` | no |
| ebs\_type | The EBS volume type to use with the Amazon ES domain, such as standard, gp2, or io1. | `string` | `"gp2"` | no |
| elasticsearch\_version | Elasticsearch Version. | `string` | `"7.1"` | no |
| encrypt\_storage\_enabled | A boolean value to determine if encryption at rest is enabled for the Elasticsearch cluster. Version must be at least 5.1. | `string` | `false` | no |
| encrypt\_traffic\_enabled | A boolean value to determine if encryption for node-to-node traffic is enabled for the Elasticsearch cluster. Version must be at least 6.0. | `string` | `false` | no |
| encryption\_kms\_key | The KMS key to use for encryption at rest on the Elasticsearch cluster.If omitted and encryption at rest is enabled, the aws/es KMS key is used. | `string` | `""` | no |
| environment | Application environment for which this network is being created. Preferred value are Development, Integration, PreProduction, Production, QA, Staging, or Test | `string` | `"Development"` | no |
| internal\_record\_name | Record Name for the new Resource Record in the Internal Hosted Zone | `string` | `""` | no |
| internal\_zone\_id | The Route53 Internal Hosted Zone ID | `string` | `""` | no |
| internal\_zone\_name | TLD for Internal Hosted Zone | `string` | `""` | no |
| ip\_whitelist | IP Addresses allowed to access the ElasticSearch Cluster.  Should be supplied if Elasticsearch cluster is not VPC enabled. | `list` | <pre>[<br>  "127.0.0.1"<br>]</pre> | no |
| logging\_application\_logs | A boolean value to determine if logging is enabled for ES\_APPLICATION\_LOGS. | `string` | `false` | no |
| logging\_index\_slow\_logs | A boolean value to determine if logging is enabled for INDEX\_SLOW\_LOGS. | `string` | `false` | no |
| logging\_retention | The number of days to retain Cloudwatch Logs for the Elasticsearch cluster. | `string` | `"30"` | no |
| logging\_search\_slow\_logs | A boolean value to determine if logging is enabled for SEARCH\_SLOW\_LOGS. | `string` | `false` | no |
| master\_node\_count | Number of master nodes in the Elasticsearch cluster.  Allowed values are 0, 3 or 5. | `string` | `3` | no |
| master\_node\_instance\_type | Select master node instance type.  See https://aws.amazon.com/elasticsearch-service/pricing/ for supported instance types. | `string` | `"m5.large.elasticsearch"` | no |
| name | The desired name for the Elasticsearch domain. | `string` | n/a | yes |
| security\_groups | A list of EC2 security groups to assign to the Elasticsearch cluster.  Ignored if Elasticsearch cluster is not VPC enabled. | `list` | `[]` | no |
| snapshot\_start\_hour | The hour (0-23) to issue a daily snapshot of Elasticsearch cluster. | `string` | `0` | no |
| subnets | Subnets for Elasticsearch cluster.  Ignored if Elasticsearch cluster is not VPC enabled. If not using Zone Awareness this should be a list of one subnet. | `list` | `[]` | no |
| tags | Additional tags to be added to the Elasticsearch cluster. | `map` | `{}` | no |
| vpc\_enabled | A boolean value to determine if the Elasticsearch cluster is VPC enabled. | `string` | `false` | no |
| zone\_awareness\_enabled | A boolean value to determine if Zone Awareness is enabled. The number of data nodes must be even if this is `true`. | `string` | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN for the Elasticsearch cluster |
| domain\_name | The domain\_name for the Elasticsearch cluster |
| endpoint | The endpoint for the Elasticsearch cluster |
| kibana\_endpoint | The kibana endpoint for the Elasticsearch cluster |
| log\_group\_arn | The ARN for the CloudWatch Log group for this Elasticsearch Cluster |
