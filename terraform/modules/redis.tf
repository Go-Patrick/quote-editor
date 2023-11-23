resource "aws_security_group" "redis_sg" {
  name = "demo1-redis-sg"
  description = "Allow traffic from ec2 into redis"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow EC2 to request into Redis"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "demo1-redis-sg"
  }
}

resource "aws_elasticache_subnet_group" "redis_subnets" {
  name = "redis-subnets"
  subnet_ids = [aws_subnet.private_3.id]
}

resource "aws_elasticache_replication_group" "redis_rep" {
  subnet_group_name = aws_elasticache_subnet_group.redis_subnets.id
  replication_group_id = var.redis_rep_id
  description = "Redis replication group for Demo1 "

  node_type = "cache.t2.micro"
  parameter_group_name = "default.redis7"
  port = 6379
  
  multi_az_enabled = false
  num_node_groups = 1
  replicas_per_node_group = 1
}

output "redis_url" {
  value = aws_elasticache_replication_group.redis_rep.reader_endpoint_address
}