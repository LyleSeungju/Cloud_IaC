variable "bucket_name" {
  description = "S3 버킷 이름"
  type        = string
}

variable "enable_website_hosting" {
  description = "정적 웹사이트 호스팅 활성화 여부"
  type        = bool
}

variable "enable_cors" {
  description = "CORS 활성화 여부"
  type        = bool
}

variable "enable_public_access" {
  description = "퍼블릭 액세스 활성화 여부"
  type        = bool
}

variable "block_public_acls" {
  description = "퍼블릭 액세스 차단 - ACL을 통한 액세스 차단 여부"
  type        = bool
}

variable "ignore_public_acls" {
  description = "퍼블릭 액세스 차단 - 기존 ACL 무시 여부"
  type        = bool
}

variable "block_public_policy" {
  description = "퍼블릭 액세스 차단 - 퍼블릭 정책 차단 여부"
  type        = bool
}

variable "restrict_public_buckets" {
  description = "퍼블릭 액세스 차단 - 퍼블릭 버킷 제한 여부"
  type        = bool
}

variable "environment" {
  description = "환경 (예: production, staging)"
  type        = string
}
