output "redis_url" {
  description = "Url address of Redis"
  value = aws_elasticache_replication_group.redis_rep.reader_endpoint_address
}