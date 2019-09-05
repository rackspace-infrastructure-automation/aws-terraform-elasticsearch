variable "name" {
  description = "The desired name for the Elasticsearch domain."
  type        = "string"
}

variable "create_service_linked_role" {
  description = "A boolean value to determine if the ElasticSearch Service Linked Role should be created.  This should only be set to true if the Service Linked Role is not already present."
  type        = "string"
  default     = false
}

variable "data_node_count" {
  description = "Number of data nodes in the Elasticsearch cluster. If using Zone Awareness this must be a multiple of the number of subnets being used, e.g. 2, 4, 6, etc. for 2 subnets or 3, 6, 9, etc. for 3 subnets."
  type        = "string"
  default     = 6
}

variable "data_node_instance_type" {
  description = "Select data node instance type.  See https://aws.amazon.com/elasticsearch-service/pricing/ for supported instance types."
  type        = "string"
  default     = "m5.large.elasticsearch"
}

variable "ebs_iops" {
  description = "The number of I/O operations per second (IOPS) that the volume supports."
  type        = "string"
  default     = 0
}

variable "ebs_size" {
  description = "The size of the EBS volume for each data node."
  type        = "string"
  default     = 35
}

variable "ebs_type" {
  description = "The EBS volume type to use with the Amazon ES domain, such as standard, gp2, or io1."
  type        = "string"
  default     = "gp2"
}

variable "elasticsearch_version" {
  description = "Elasticsearch Version."
  type        = "string"
  default     = "7.1"
}

variable "encrypt_storage_enabled" {
  description = "A boolean value to determine if encryption at rest is enabled for the Elasticsearch cluster. Version must be at least 5.1."
  type        = "string"
  default     = false
}

variable "encrypt_traffic_enabled" {
  description = "A boolean value to determine if encryption for node-to-node traffic is enabled for the Elasticsearch cluster. Version must be at least 6.0."
  type        = "string"
  default     = false
}

variable "encryption_kms_key" {
  description = "The KMS key to use for encryption at rest on the Elasticsearch cluster.If omitted and encryption at rest is enabled, the aws/es KMS key is used."
  type        = "string"
  default     = ""
}

variable "environment" {
  description = "Application environment for which this network is being created. Preferred value are Development, Integration, PreProduction, Production, QA, Staging, or Test"
  type        = "string"
  default     = "Development"
}

variable "internal_record_name" {
  description = "Record Name for the new Resource Record in the Internal Hosted Zone"
  type        = "string"
  default     = ""
}

variable "internal_zone_id" {
  description = "The Route53 Internal Hosted Zone ID"
  type        = "string"
  default     = ""
}

variable "internal_zone_name" {
  description = "TLD for Internal Hosted Zone"
  type        = "string"
  default     = ""
}

variable "ip_whitelist" {
  description = "IP Addresses allowed to access the ElasticSearch Cluster.  Should be supplied if Elasticsearch cluster is not VPC enabled."
  type        = "list"
  default     = ["127.0.0.1"]
}

variable "logging_application_logs" {
  description = "A boolean value to determine if logging is enabled for ES_APPLICATION_LOGS."
  type        = "string"
  default     = false
}

variable "logging_index_slow_logs" {
  description = "A boolean value to determine if logging is enabled for INDEX_SLOW_LOGS."
  type        = "string"
  default     = false
}

variable "logging_retention" {
  description = "The number of days to retain Cloudwatch Logs for the Elasticsearch cluster."
  type        = "string"
  default     = "30"
}

variable "logging_search_slow_logs" {
  description = "A boolean value to determine if logging is enabled for SEARCH_SLOW_LOGS."
  type        = "string"
  default     = false
}

variable "master_node_count" {
  description = "Number of master nodes in the Elasticsearch cluster.  Allowed values are 0, 3 or 5."
  type        = "string"
  default     = 3
}

variable "master_node_instance_type" {
  description = "Select master node instance type.  See https://aws.amazon.com/elasticsearch-service/pricing/ for supported instance types."
  type        = "string"
  default     = "m5.large.elasticsearch"
}

variable "security_groups" {
  description = "A list of EC2 security groups to assign to the Elasticsearch cluster.  Ignored if Elasticsearch cluster is not VPC enabled."
  type        = "list"
  default     = []
}

variable "snapshot_start_hour" {
  description = "The hour (0-23) to issue a daily snapshot of Elasticsearch cluster."
  type        = "string"
  default     = 0
}

variable "subnets" {
  description = "Subnets for Elasticsearch cluster.  Ignored if Elasticsearch cluster is not VPC enabled. If not using Zone Awareness this should be a list of one subnet."
  type        = "list"
  default     = []
}

variable "tags" {
  description = "Additional tags to be added to the Elasticsearch cluster."
  type        = "map"
  default     = {}
}

variable "vpc_enabled" {
  description = "A boolean value to determine if the Elasticsearch cluster is VPC enabled."
  type        = "string"
  default     = false
}

variable "zone_awareness_enabled" {
  description = "A boolean value to determine if Zone Awareness is enabled. The number of data nodes must be even if this is `true`."
  type        = "string"
  default     = "true"
}
