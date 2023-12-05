resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = "true"
  enable_dns_support = "true"

  tags = {
    "Name" = "demo1-vpc"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "demo1-gw"
  }
}

resource "aws_subnet" "load_balance_1" {
  vpc_id = aws_vpc.main.id
  availability_zone   = "ap-southeast-1a"
  cidr_block = var.vpc_subnet_cidr_block[0]
}

resource "aws_subnet" "load_balance_2" {
  vpc_id = aws_vpc.main.id
  availability_zone   = "ap-southeast-1b"
  cidr_block = var.vpc_subnet_cidr_block[1]
}

resource "aws_subnet" "rds_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[0]
}

resource "aws_subnet" "rds_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[1]
}

resource "aws_subnet" "redis" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[2]
}

resource "aws_subnet" "auto_scaling_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[3]
}

resource "aws_subnet" "auto_scaling_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[4]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }
}

resource "aws_route_table_association" "load_balance_1" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.load_balance_1.id
}

resource "aws_route_table_association" "load_balance_2" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.load_balance_2.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "rds_1" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.rds_1.id
}

resource "aws_route_table_association" "rds_2" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.rds_2.id
}

resource "aws_route_table_association" "redis" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.redis.id
}

resource "aws_route_table_association" "auto_scaling_1" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.auto_scaling_1.id
}

resource "aws_route_table_association" "auto_scaling_2" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.auto_scaling_2.id
}

resource "aws_security_group" "elb_sg" {
  name = "demo1-elb-sg"
  description = "Security group for load balancer"

  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow HTTP request"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS request"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "demo1-elb-sg"
  }
}

resource "aws_security_group" "public_sg" {
  name = "demo1-ec2-sg"
  description = "Security group for ec2 instances"

  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow HTTP request"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS request"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH request"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "demo1-ec2-sg"
  }
}

resource "aws_security_group" "redis_sg" {
  name = "demo1-redis-sg"
  description = "Allow traffic from ec2 into redis"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow EC2 to request into Redis"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_security_group" "db_sg" {
  name = "demo1-rds-sg"
  description = "Security group for RDS"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow request from ec2 instance"
    from_port = 5432
    to_port = 5432
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
    "Name" = "demo1-rds-sg"
  }
}