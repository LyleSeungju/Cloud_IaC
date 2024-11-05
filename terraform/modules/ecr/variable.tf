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