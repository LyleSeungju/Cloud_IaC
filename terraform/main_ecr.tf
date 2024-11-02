variable "is_ecr" {
  description = "ECR 리소스를 생성할지 여부"
  type        = bool
  default     = true
}

variable "ecr_repositories" {
  description = "생성할 ECR 리포지토리 설정 목록"
  type = list(object({
    name                   = string            # ECR 리포지토리의 이름을 지정합니다.
    image_tag_mutability   = string            # 이미지 태그 변경 가능 여부를 지정합니다. ("IMMUTABLE" 또는 "MUTABLE") : Default는 MUTABLE
    image_scanning_enabled = bool              # 이미지 스캔을 활성화할지 여부를 지정합니다 (true/false). : Default는 false
    lifecycle_policy       = bool              # 라이프사이클 정책을 활성화할지 여부를 지정합니다. true이면 기본 정책이 적용됩니다. : 언태그된 이미지일시 30일 후 삭제
    tags                   = map(string)       # 리포지토리에 추가할 태그 목록입니다 (key-value 형식).
  }))
  default = []
}

# 기본 라이프사이클 정책 정의
locals {
  default_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 30 days to optimize storage costs"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# `lifecycle_policy`가 true인 경우 기본 정책, false인 경우 빈 문자열
locals {
  repositories_with_policy = [
    for repo in var.ecr_repositories : merge(repo, {
      lifecycle_policy = repo.lifecycle_policy ? local.default_lifecycle_policy : ""
    })
  ]
}

module "ecr" {
  source       = "./modules/ecr"
  repositories = var.is_ecr ? local.repositories_with_policy : []
}