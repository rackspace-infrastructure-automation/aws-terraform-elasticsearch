variable "create_service_linked_role" {
  description = "A boolean value to determine if the ElasticSearch Service Linked Role should be created.  This should only be set to true if the Service Linked Role is not already present."
  default     = false
  type        = "string"
}

variable "data_node_count" {
  description = "Number of data nodes in the Elasticsearch cluster. If using Zone Awareness this must be a multiple of the number of subnets being used, e.g. 2, 4, 6, etc. for 2 subnets or 3, 6, 9, etc. for 3 subnets."
  default     = 6
  type        = "string"
}

variable "data_node_instance_type" {
  description = "Select data node instance type.  See https://aws.amazon.com/elasticsearch-service/pricing/ for supported instance types."
  default     = "m5.large.elasticsearch"
  type        = "string"
}

variable "ebs_iops" {
  description = "The number of I/O operations per second (IOPS) that the volume supports."
  default     = 0
  type        = "string"
}

variable "ebs_size" {
  description = "The size of the EBS volume for each data node."
  default     = 35
  type        = "string"
}

variable "ebs_type" {
  description = "The EBS volume type to use with the Amazon ES domain, such as standard, gp2, or io1."
  default     = "gp2"
  type        = "string"
}

variable "elasticsearch_version" {
  description = "Elasticsearch Version."
  default     = "7.1"
  type        = "string"
}

variable "encrypt_storage_enabled" {
  description = "A boolean value to determine if encryption at rest is enabled for the Elasticsearch cluster. Version must be at least 5.1."
  default     = false
  type        = "string"
}

variable "encrypt_traffic_enabled" {
  description = "A boolean value to determine if encryption for node-to-node traffic is enabled for the Elasticsearch cluster. Version must be at least 6.0."
  default     = false
  type        = "string"
}

variable "encryption_kms_key" {
  description = "The KMS key to use for encryption at rest on the Elasticsearch cluster.If omitted and encryption at rest is enabled, the aws/es KMS key is used."
  default     = ""
  type        = "string"
}

variable "environment" {
  description = "Application environment for which this network is being created. Preferred value are Development, Integration, PreProduction, Production, QA, Staging, or Test"
  default     = "Development"
  type        = "string"
}

variable "internal_record_name" {
  description = "Record Name for the new Resource Record in the Internal Hosted Zone"
  default     = ""
  type        = "string"
}

variable "internal_zone_id" {
  description = "The Route53 Internal Hosted Zone ID"
  default     = ""
  type        = "string"
}

variable "internal_zone_name" {
  description = "TLD for Internal Hosted Zone"
  default     = ""
  type        = "string"
}

variable "ip_whitelist" {
  description = "IP Addresses allowed to access the ElasticSearch Cluster.  Should be supplied if Elasticsearch cluster is not VPC enabled."
  default     = ["127.0.0.1"]
  type        = "list"
}

variable "logging_application_logs" {
  description = "A boolean value to determine if logging is enabled for ES_APPLICATION_LOGS."
  default     = false
  type        = "string"
}

variable "logging_index_slow_logs" {
  description = "A boolean value to determine if logging is enabled for INDEX_SLOW_LOGS."
  default     = false
  type        = "string"
}

variable "logging_retention" {
  description = "The number of days to retain Cloudwatch Logs for the Elasticsearch cluster."
  default     = "30"
  type        = "string"
}

variable "logging_search_slow_logs" {
  description = "A boolean value to determine if logging is enabled for SEARCH_SLOW_LOGS."
  default     = false
  type        = "string"
}

variable "master_node_count" {
  description = "Number of master nodes in the Elasticsearch cluster.  Allowed values are 0, 3 or 5."
  default     = 3
  type        = "string"
}

variable "master_node_instance_type" {
  description = "Select master node instance type.  See https://aws.amazon.com/elasticsearch-service/pricing/ for supported instance types."
  default     = "m5.large.elasticsearch"
  type        = "string"
}

variable "name" {
  description = "The desired name for the Elasticsearch domain."
  type        = "string"
}

variable "security_groups" {
  description = "A list of EC2 security groups to assign to the Elasticsearch cluster.  Ignored if Elasticsearch cluster is not VPC enabled."
  default     = []
  type        = "list"
}

variable "snapshot_start_hour" {
  description = "The hour (0-23) to issue a daily snapshot of Elasticsearch cluster."
  default     = 0
  type        = "string"
}

variable "subnets" {
  description = "Subnets for Elasticsearch cluster.  Ignored if Elasticsearch cluster is not VPC enabled. If not using Zone Awareness this should be a list of one subnet."
  default     = []
  type        = "list"
}

variable "tags" {
  description = "Additional tags to be added to the Elasticsearch cluster."
  default     = {}
  type        = "map"
}

variable "vpc_enabled" {
  description = "A boolean value to determine if the Elasticsearch cluster is VPC enabled."
  default     = false
  type        = "string"
}

variable "zone_awareness_enabled" {
  description = "A boolean value to determine if Zone Awareness is enabled. The number of data nodes must be even if this is `true`."
  default     = "true"
  type        = "string"
}
