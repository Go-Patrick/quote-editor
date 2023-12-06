variable "redis_sg" {}
variable "subnet_list" {
  type = list(string)
  description = "List of subnet IDs"
}

variable "redis_rep_id" {
  type = string
  description = "Replication id for Redis cluster"
  default = "redis-cluster"
}