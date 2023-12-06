variable "subnet_list" {
  type = list(string)
  description = "List of subnet IDs"
}
variable "db_sg" {
  type = list(string)
  description = "Security group for RDS instance"
}

variable "ec2_ami" {
  type = string
  description = "AMI to create EC2 instance to manage RDS"
}

variable "rds_control_subnet" {
  type = string
  description = "Subnet for EC2 control RDS"
}

variable "rds_control_sg" {
  type = string
  description = "Security group for EC2 control RDS"
}

variable "db_username" {
  type = string
}
variable "db_password" {
  type = string
}
variable "db_name" {
  type = string
}
variable "db_identifier" {
  type = string
}