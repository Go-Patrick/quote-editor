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

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db-subnets"
  description = "Subnet group for private database"

  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "15.2"
  instance_class         = "db.t3.micro"
  db_name = var.db_name
  identifier = var.db_identifier
  username               = var.db_username
  password               = var.db_password
  publicly_accessible    = false
  # parameter_group_name   = "default.postgres12"
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  skip_final_snapshot    = true
}

output "database_url" {
  value = aws_db_instance.postgres.address
  description = "Url address of database"
}