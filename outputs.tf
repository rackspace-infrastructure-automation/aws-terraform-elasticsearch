output "arn" {
  description = "The ARN for the Elasticsearch cluster"
  value       = aws_elasticsearch_domain.es.*.arn
}

output "domain_name" {
  description = "The domain_name for the Elasticsearch cluster"
  value       = aws_elasticsearch_domain.es.*.domain_name
}

output "endpoint" {
  description = "The endpoint for the Elasticsearch cluster"
  value       = aws_elasticsearch_domain.es.*.endpoint
}

output "kibana_endpoint" {
  description = "The kibana endpoint for the Elasticsearch cluster"
  value       = aws_elasticsearch_domain.es.*.kibana_endpoint
}

output "log_group_arn" {
  description = "The ARN for the CloudWatch Log group for this Elasticsearch Cluster"
  value       = aws_cloudwatch_log_group.es.*.arn
}

