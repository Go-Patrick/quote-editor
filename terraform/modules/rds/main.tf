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

resource "aws_instance" "ec2_instance" {
  ami                    = var.ec2_ami
  instance_type          = "t2.micro"
  key_name               = "demo1-key"
  subnet_id              = var.rds_control_subnet
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install postgresql11 -y
              sudo yum install postgresql-server -y
              sudo service postgresql start
              sudo chkconfig postgresql on
              EOF

  tags = {
    Name = "EC2InstanceForRDSManagement"
  }
}