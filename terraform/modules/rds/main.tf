resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db-subnets"
  description = "Subnet group for private database"

  subnet_ids = var.subnet_list
}

resource "aws_db_instance" "app_db_instance" {
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
  vpc_security_group_ids = var.db_sg
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  skip_final_snapshot    = true
}