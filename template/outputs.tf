output "repository_url" {
  description = "ECR 레포지토리 URL"
  value       = aws_ecr_repository.ecr-repository.repository_url
}

output "repository_arn" {
  description = "ECR 레포지토리 ARN"
  value       = aws_ecr_repository.ecr-repository.arn
}
