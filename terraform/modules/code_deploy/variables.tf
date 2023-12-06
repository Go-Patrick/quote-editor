variable "code_deploy_role_arn" {
  type = string
  description = "CodeDeploy role ARN"
  default = "arn:aws:iam::932782693588:role/IAMCodeDeployRole"
}
variable "auto_scaling_group_id" {
  type = string
  description = "Auto scaling group ID"
}