resource "aws_elasticache_subnet_group" "redis_subnets" {
  name = "redis-subnets"
  subnet_ids = var.subnet_list
}

resource "aws_elasticache_replication_group" "redis_rep" {
  subnet_group_name = aws_elasticache_subnet_group.redis_subnets.id
  replication_group_id = var.redis_rep_id
  security_group_ids = [var.redis_sg]
  description = "Redis replication group for Demo1 "

  node_type = "cache.t2.micro"
  parameter_group_name = "default.redis7"
  port = 6379

  multi_az_enabled = false
  num_node_groups = 1
  replicas_per_node_group = 1
}