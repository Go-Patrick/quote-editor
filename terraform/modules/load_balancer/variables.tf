variable "vpc" {
  type = string
  description = "VPC ID"
}
variable "subnet_list" {
  type = list(string)
  description = "List of subnet IDs"
}
variable "security_group" {
  type = string
  description = "Security group ID"
}
variable "auto_scaling_group_name" {
  type = string
  description = "Auto scaling group name"
}