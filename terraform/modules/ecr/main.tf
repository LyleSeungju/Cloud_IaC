variable "repositories" {
  description = "ECR 리포지토리 설정 목록"
  type = list(object({
    name                     = string
    image_tag_mutability     = string
    image_scanning_enabled   = bool
    lifecycle_policy         = optional(string) # 라이프사이클 정책 JSON
    tags                     = map(string)
  }))
}

resource "aws_ecr_repository" "this" {
  for_each               = { for repo in var.repositories : repo.name => repo }
  name                   = each.value.name
  image_tag_mutability   = each.value.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = each.value.image_scanning_enabled
  }

  tags = merge(each.value.tags, { Name = each.value.name })
}

# `lifecycle_policy`가 빈 문자열이 아닌 경우에만 생성
resource "aws_ecr_lifecycle_policy" "this" {
  for_each = {
    for repo in var.repositories : repo.name => repo
    if lookup(repo, "lifecycle_policy", "") != ""
  }
  repository = aws_ecr_repository.this[each.key].name
  policy     = each.value.lifecycle_policy
}

# Outputs
output "repository_urls" {
  description = "각 ECR 리포지토리의 URL 목록"
  value       = { for key, repo in aws_ecr_repository.this : key => repo.repository_url }
}
