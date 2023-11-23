resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = "true"
  enable_dns_support = "true"

  tags = {
    "Name" = "demo1-vpc"
  }
}

resource "aws_internet_gateway" "interner_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "demo1-gw"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  availability_zone   = "ap-southeast-1a"
  cidr_block = var.vpc_subnet_cidr_block[0]
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  availability_zone   = "ap-southeast-1b"
  cidr_block = var.vpc_subnet_cidr_block[1]
}

resource "aws_subnet" "public_3" {
  vpc_id = aws_vpc.main.id
  availability_zone   = "ap-southeast-1a"
  cidr_block = var.vpc_subnet_cidr_block[2]
}

resource "aws_subnet" "public_4" {
  vpc_id = aws_vpc.main.id
  availability_zone   = "ap-southeast-1b"
  cidr_block = var.vpc_subnet_cidr_block[3]
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1a"
  cidr_block = var.vpc_private_cidr_block[0]
}

resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[1]
}

resource "aws_subnet" "private_3" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-southeast-1b"
  cidr_block = var.vpc_private_cidr_block[2]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.interner_gw.id
  }
}

# resource "aws_route_table_association" "public_1" {
#   route_table_id = aws_route_table.public_rt.id
#   subnet_id = aws_subnet.public_1.id
# }

# resource "aws_route_table_association" "public_2" {
#   route_table_id = aws_route_table.public_rt.id
#   subnet_id = aws_subnet.public_2.id
# }

resource "aws_route_table_association" "public_3" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public_3.id
}

resource "aws_route_table_association" "public_4" {
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public_4.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private_1" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_1.id
}

resource "aws_route_table_association" "private_2" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_2.id
}

resource "aws_route_table_association" "private_3" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id = aws_subnet.private_3.id
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