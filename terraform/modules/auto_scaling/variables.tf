variable "linux_ami_id" {
  type = string
  description = "Image id for launch template "
}
variable "userdata_path" {
  type = string
  description = "Path to userdata template"
}
variable "security_group" {
  type = string
  description = "Security group ID"
}
variable "subnet_list" {
  type = list(string)
  description = "List of subnet IDs"
}
variable "iam_instance_profile_arn" {
  type = string
  description = "ARN of instance profile"
}