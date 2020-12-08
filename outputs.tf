output "arn" {
  description = "The ARN for the Elasticsearch cluster"
  value       = element(compact(concat(aws_elasticsearch_domain.es[*].arn, aws_elasticsearch_domain.es_domain_undestroyable[*].arn)), 0)
}

output "domain_name" {
  description = "The domain_name for the Elasticsearch cluster"
  value       = element(compact(concat(aws_elasticsearch_domain.es[*].domain_name, aws_elasticsearch_domain.es_domain_undestroyable[*].domain_name)), 0)
}

output "endpoint" {
  description = "The endpoint for the Elasticsearch cluster"
  value       = element(compact(concat(aws_elasticsearch_domain.es[*].endpoint, aws_elasticsearch_domain.es_domain_undestroyable[*].endpoint)), 0)
}

output "kibana_endpoint" {
  description = "The kibana endpoint for the Elasticsearch cluster"
  value       = element(compact(concat(aws_elasticsearch_domain.es[*].kibana_endpoint, aws_elasticsearch_domain.es_domain_undestroyable[*].kibana_endpoint)), 0)
}

output "log_group_arn" {
  description = "The ARN for the CloudWatch Log group for this Elasticsearch Cluster"
  value       = aws_cloudwatch_log_group.es.*.arn
}

