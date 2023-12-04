variable "code_deploy_role_arn" {
  type = string
  default = "arn:aws:iam::932782693588:role/IAMCodeDeployRole"
}

variable "s3_bucket_name" {
  type = string
  default = "quote-editor-deploy-bucket"
}

variable "iam_user_arn" {
  type = string
  default = "932782693588"
}