output "ecr_url" {
  value = aws_ecr_repository.app_registry.repository_url
  description = "The URL of the ECR repository"
}