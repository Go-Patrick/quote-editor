output "vpc" {
  value = aws_vpc.main
}

output "subnet_load_balance_1" {
  value = aws_subnet.load_balance_1
}

output "subnet_load_balance_2" {
  value = aws_subnet.load_balance_2
}

output "subnet_auto_scaling_1" {
  value = aws_subnet.auto_scaling_1
}

output "subnet_auto_scaling_2" {
  value = aws_subnet.auto_scaling_2
}

output "subnet_rds_1" {
  value = aws_subnet.rds_1
}

output "subnet_rds_2" {
  value = aws_subnet.rds_2
}

output "subnet_redis" {
  value = aws_subnet.redis
}

output "public_sg" {
  value = aws_security_group.public_sg
}

output "elb_sg" {
  value = aws_security_group.elb_sg
}

output "rds_sg" {
  value = aws_security_group.db_sg
}

output "redis_sg" {
  value = aws_security_group.redis_sg
}