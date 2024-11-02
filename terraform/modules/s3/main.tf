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

# S3 버킷 생성
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# 퍼블릭 액세스 차단을 위한 별도 리소스 생성
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
}

# 정적 웹사이트 호스팅을 별도의 리소스로 구성
resource "aws_s3_bucket_website_configuration" "this" {
  count = var.enable_website_hosting ? 1 : 0
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# CORS 설정
resource "aws_s3_bucket_cors_configuration" "this" {
  count  = var.enable_cors ? 1 : 0
  bucket = aws_s3_bucket.this.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

output "bucket_name" {
  description = "생성된 S3 버킷 이름"
  value       = aws_s3_bucket.this.bucket
}

# 정적 웹사이트 호스팅이 활성화된 경우에만 출력
output "website_endpoint" {
  description = "정적 웹사이트 엔드포인트 (정적 웹 호스팅이 활성화된 경우)"
  value       = length(aws_s3_bucket_website_configuration.this) > 0 ? aws_s3_bucket_website_configuration.this[0].website_endpoint : null
}