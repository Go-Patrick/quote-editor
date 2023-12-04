resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db-subnets"
  description = "Subnet group for private database"

  subnet_ids = [var.subnet_1, var.subnet_2]
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
  vpc_security_group_ids = [var.db_sg]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.id
  skip_final_snapshot    = true
}

output "database_url" {
  value = aws_db_instance.postgres.address
  description = "Url address of database"
}