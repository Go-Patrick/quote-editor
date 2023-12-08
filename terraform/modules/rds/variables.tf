variable "subnet_list" {
  type = list(string)
  description = "List of subnet IDs"
}
variable "db_sg" {
  type = list(string)
  description = "Security group for RDS instance"
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