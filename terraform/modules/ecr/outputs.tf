output "ecr_url" {
  value = aws_ecr_repository.ecr.repository_url
  description = "The URL of the ECR repository"
}