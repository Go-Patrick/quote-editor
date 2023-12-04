variable "redis_sg" {}
variable "subnet" {}

variable "redis_rep_id" {
  type = string
  default = "redis-cluster"
}