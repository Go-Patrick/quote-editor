variable "region" {
  type = string
  default = "ap-southeast-1"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_subnet_cidr_block" {
  type = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
  ]
}

variable "vpc_private_cidr_block" {
  type = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
  ]
}

variable "redis_rep_id" {
  type = string
  default = "redis-cluster"
}

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

variable "db_username" {}
variable "db_password" {}
variable "db_name" {}
variable "db_identifier" {}