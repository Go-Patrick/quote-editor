variable "code_deploy_role_arn" {
  type = string
  description = "ARN of code deploy role"
}

variable "s3_bucket_name" {
  type = string
  description = "Unique name for S3 storage of bucket used for deployment"
}

variable "iam_user_arn" {
  type = string
  description = "IAM user arn"
}