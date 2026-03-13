output "repository_id" {
  description = "ECR 리포지토리 ID"
  value       = aws_ecr_repository.this.id
}

output "repository_arn" {
  description = "ECR 리포지토리 ARN"
  value       = aws_ecr_repository.this.arn
}

output "repository_url" {
  description = "ECR 리포지토리 URL (docker push/pull에 사용)"
  value       = aws_ecr_repository.this.repository_url
}

output "registry_id" {
  description = "ECR 레지스트리 ID (AWS 계정 ID)"
  value       = aws_ecr_repository.this.registry_id
}
