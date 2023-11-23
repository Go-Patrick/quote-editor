resource "aws_ecr_repository" "ecr" {
  name = "quote-app"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_url" {
  value = aws_ecr_repository.ecr.repository_url
  description = "The URL of the ECR repository"
}