[!CAUTION]
This project is end of life. This repo will be deleted on June 2nd 2025.


# aws-terraform-elasticsearch

This module creates an ElasticSearch cluster.

## Basic Usage

### Internet accessible endpoint

```HCL
module "elasticsearch" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.12.4"

  name          = "es-internet-endpoint"
  ip_whitelist  = ["1.2.3.4"]
}
```

### VPC accessible endpoint

```HCL
module "elasticsearch" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.12.4"

  name            = "es-vpc-endpoint"
  vpc_enabled     = true
  security_groups = [module.sg.public_web_security_group_id]
  subnets         = [module.vpc.private_subnets]
}
```

Full working references are available at [examples](examples)

## Limitation

Terraform does not create the IAM Service Linked Role for ElasticSearch automatically.  If this role is not present on an account, the `create_service_linked_role` parameter should be set to true for the first ElasticSearch instance.  This will create the required role.  This option should not be set to true on more than a single deployment per account, or it will result in a naming conflict.  If the role is not present an error similar to the following would result:  
Error creating ElasticSearch domain: ValidationException: Before you can proceed, you must enable a service-linked role to give Amazon ES permissions to access your VPC.
```
1 error(s) occurred:

* module.elasticsearch.aws_elasticsearch_domain.es: 1 error(s) occurred:

* aws_elasticsearch_domain.es: Error reading IAM Role AWSServiceRoleForAmazonElasticsearchService: NoSuchEntity: The role with name AWSServiceRoleForAmazonElasticsearchService cannot be found.
    status code: 404, request id: 5a1614d2-1e64-11e9-a87e-3149d48d2026
```

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.2.0 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| create\_service\_linked\_role | A boolean value to determine if the ElasticSearch Service Linked Role should be created.  This should only be set to true if the Service Linked Role is not already present. | `bool` | `false` | no |
| custom\_access\_policy | The custom access policy as string of JSON. | `string` | `""` | no |
| data\_node\_count | Number of data nodes in the Elasticsearch cluster. If using Zone Awareness this must be a multiple of the number of subnets being used, e.g. 2, 4, 6, etc. for 2 subnets or 3, 6, 9, etc. for 3 subnets. | `number` | `6` | no |
| data\_node\_instance\_type | Select data node instance type.  See https://aws.amazon.com/elasticsearch-service/pricing/ for supported instance types. | `string` | `"m5.large.elasticsearch"` | no |
| ebs\_iops | The number of I/O operations per second (IOPS) that the volume supports. | `number` | `0` | no |
| ebs\_size | The size of the EBS volume for each data node. | `number` | `35` | no |
| ebs\_type | The EBS volume type to use with the Amazon ES domain, such as standard, gp2, or io1. | `string` | `"gp2"` | no |
| elasticsearch\_version | Elasticsearch Version. | `string` | `"7.1"` | no |
| encrypt\_storage\_enabled | A boolean value to determine if encryption at rest is enabled for the Elasticsearch cluster. Version must be at least 5.1. | `bool` | `false` | no |
| encrypt\_traffic\_enabled | A boolean value to determine if encryption for node-to-node traffic is enabled for the Elasticsearch cluster. Version must be at least 6.0. | `bool` | `false` | no |
| encryption\_kms\_key | The KMS key to use for encryption at rest on the Elasticsearch cluster.If omitted and encryption at rest is enabled, the aws/es KMS key is used. | `string` | `""` | no |
| environment | Application environment for which this network is being created. Preferred value are Development, Integration, PreProduction, Production, QA, Staging, or Test | `string` | `"Development"` | no |
| internal\_record\_name | Record Name for the new Resource Record in the Internal Hosted Zone | `string` | `""` | no |
| internal\_zone\_id | The Route53 Internal Hosted Zone ID | `string` | `""` | no |
| internal\_zone\_name | TLD for Internal Hosted Zone | `string` | `""` | no |
| ip\_whitelist | IP Addresses allowed to access the ElasticSearch Cluster.  Should be supplied if Elasticsearch cluster is not VPC enabled. | `list(string)` | <pre>[<br>  "127.0.0.1"<br>]</pre> | no |
| logging\_application\_logs | A boolean value to determine if logging is enabled for ES\_APPLICATION\_LOGS. | `bool` | `false` | no |
| logging\_index\_slow\_logs | A boolean value to determine if logging is enabled for INDEX\_SLOW\_LOGS. | `bool` | `false` | no |
| logging\_retention | The number of days to retain Cloudwatch Logs for the Elasticsearch cluster. | `number` | `30` | no |
| logging\_search\_slow\_logs | A boolean value to determine if logging is enabled for SEARCH\_SLOW\_LOGS. | `bool` | `false` | no |
| master\_node\_count | Number of master nodes in the Elasticsearch cluster.  Allowed values are 0, 3 or 5. | `number` | `3` | no |
| master\_node\_instance\_type | Select master node instance type.  See https://aws.amazon.com/elasticsearch-service/pricing/ for supported instance types. | `string` | `"m5.large.elasticsearch"` | no |
| max\_clause\_count | Note the use of a string rather than an integer. Specifies the maximum number of clauses allowed in a Lucene boolean query. 1024 is the default. Queries with more than the permitted number of clauses that result in a TooManyClauses error. | `string` | `"1024"` | no |
| name | The desired name for the Elasticsearch domain. | `string` | n/a | yes |
| security\_groups | A list of EC2 security groups to assign to the Elasticsearch cluster.  Ignored if Elasticsearch cluster is not VPC enabled. | `list(string)` | `[]` | no |
| snapshot\_start\_hour | The hour (0-23) to issue a daily snapshot of Elasticsearch cluster. | `number` | `0` | no |
| subnets | Subnets for Elasticsearch cluster.  Ignored if Elasticsearch cluster is not VPC enabled. If not using Zone Awareness this should be a list of one subnet. | `list(string)` | `[]` | no |
| tags | Additional tags to be added to the Elasticsearch cluster. | `map(string)` | `{}` | no |
| use\_custom\_access\_policy | Use a custom access policy instead of VPC or IP Based. Insert policy in `custom_access_policy` | `bool` | `false` | no |
| vpc\_enabled | A boolean value to determine if the Elasticsearch cluster is VPC enabled. | `bool` | `false` | no |
| zone\_awareness\_enabled | A boolean value to determine if Zone Awareness is enabled. The number of data nodes must be even if this is `true`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN for the Elasticsearch cluster |
| domain\_name | The domain\_name for the Elasticsearch cluster |
| endpoint | The endpoint for the Elasticsearch cluster |
| kibana\_endpoint | The kibana endpoint for the Elasticsearch cluster |
| log\_group\_arn | The ARN for the CloudWatch Log group for this Elasticsearch Cluster |

