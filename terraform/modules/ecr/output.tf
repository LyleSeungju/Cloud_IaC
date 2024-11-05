# Outputs
output "repository_urls" {
  description = "각 ECR 리포지토리의 URL 목록"
  value       = { for key, repo in aws_ecr_repository.this : key => repo.repository_url }
}