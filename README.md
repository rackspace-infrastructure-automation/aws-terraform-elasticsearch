# aws-terraform-elasticsearch

This module creates an ElasticSearch cluster.

## Basic Usage

### Internet accessible endpoint
```
module "elasticsearch" {
 source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.0.1"

 name          = "titus-test-es-internet-endpoint"
 ip_whitelist  = ["1.2.3.4"]
}
```

### VPC accessible endpoint
```
module "elasticsearch" {
 source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-elasticsearch//?ref=v0.0.1"

 name          = "titus-test-es-internet-endpoint"
 vpc_enabled     = true
 security_groups = ["${module.sg.public_web_security_group_id}"]
 subnets         = ["${module.vpc.private_subnets}"]
}
```

Full working references are available at [examples](examples)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| data\_node\_count | Number of data nodes in the Elasticsearch cluster. If using Zone Awareness this must be an even number. | string | `"6"` | no |
| data\_node\_instance\_type | Select data node instance type.  See https://aws.amazon.com/elasticsearch-service/pricing/ for supported instance types. | string | `"m4.large.elasticsearch"` | no |
| ebs\_iops | The number of I/O operations per second (IOPS) that the volume supports. | string | `"0"` | no |
| ebs\_size | The size of the EBS volume for each data node. | string | `"20"` | no |
| ebs\_type | The EBS volume type to use with the Amazon ES domain, such as standard, gp2, or io1. | string | `"gp2"` | no |
| elasticsearch\_version | Elasticsearch Version. | string | `"6.3"` | no |
| encryption\_enabled | A boolean value to determine if encryption at rest is enabled for the Elasticsearch cluster. | string | `"false"` | no |
| encryption\_kms\_key | The KMS key to use for encryption at rest on the Elasticsearch cluster.If omitted and encryption at rest is enabled, the aws/es KMS key is used. | string | `""` | no |
| environment | Application environment for which this network is being created. Preferred value are Development, Integration, PreProduction, Production, QA, Staging, or Test | string | `"Development"` | no |
| internal\_record\_name | Record Name for the new Resource Record in the Internal Hosted Zone. i.e. es | string | `""` | no |
| internal\_zone\_name | TLD for Internal Hosted Zone. i.e. mycompany.local | string | `""` | no |
| ip\_whitelist | IP Addresses allowed to access the ElasticSearch Cluster.  Should be supplied if Elasticsearch cluster is not VPC enabled. | list | `<list>` | no |
| logging\_application\_logs | A boolean value to determine if logging is enabled for ES_APPLICATION_LOGS. | string | `"false"` | no |
| logging\_index\_slow\_logs | A boolean value to determine if logging is enabled for INDEX_SLOW_LOGS. | string | `"false"` | no |
| logging\_retention | The number of days to retain Cloudwatch Logs for the Elasticsearch cluster. | string | `"30"` | no |
| logging\_search\_slow\_logs | A boolean value to determine if logging is enabled for SEARCH_SLOW_LOGS. | string | `"false"` | no |
| master\_node\_count | Number of master nodes in the Elasticsearch cluster.  Allowed values are 0, 3 or 5. | string | `"3"` | no |
| master\_node\_instance\_type | Select master node instance type.  See https://aws.amazon.com/elasticsearch-service/pricing/ for supported instance types. | string | `"m4.large.elasticsearch"` | no |
| name | The desired name for the Elasticsearch domain. | string | n/a | yes |
| security\_groups | A list of EC2 security groups to assign to the Elasticsearch cluster.  Ignored if Elasticsearch cluster is not VPC enabled. | list | `<list>` | no |
| snapshot\_start\_hour | The hour (0-23) to issue a daily snapshot of Elasticsearch cluster. | string | `"0"` | no |
| subnets | Subnets for Elasticsearch cluster.  Ignored if Elasticsearch cluster is not VPC enabled. If not using Zone Awareness this should be a list of one subnet. | list | `<list>` | no |
| tags | Additional tags to be added to the Elasticsearch cluster. | map | `<map>` | no |
| vpc\_enabled | A boolean value to determine if the Elasticsearch cluster is VPC enabled. | string | `"false"` | no |
| zone\_awareness\_enabled | A boolean value to determine if Zone Awareness is enabled. The number of data nodes must be even if this is `true`. | string | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN for the Elasticsearch cluster |
| endpoint | The endpoint for the Elasticsearch cluster |
| kibana\_endpoint | The kibana endpoint for the Elasticsearch cluster |
| log\_group\_arn | The ARN for the CloudWatch Log group for this Elasticsearch Cluster |

