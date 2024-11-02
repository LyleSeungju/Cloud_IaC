variable "s3_buckets" {
  description = "생성할 S3 버킷 설정 목록"
  type = map(object({
    bucket_name             = string        # S3 버킷의 이름을 지정합니다.
    enable_website_hosting  = bool          # 정적 웹사이트 호스팅을 활성화할지 여부 (true/false)
    enable_cors             = bool          # Cross-origin 리소스 공유(CORS) 설정을 활성화할지 여부 (true/false)
    enable_public_access    = bool          # 퍼블릭 접근을 허용할지 여부 (true/false)
    block_public_acls       = bool          # 퍼블릭 ACL을 통해 부여된 액세스를 차단할지 여부 (true/false)
    ignore_public_acls      = bool          # 퍼블릭 ACL을 무시할지 여부 (true/false)
    block_public_policy     = bool          # 퍼블릭 정책을 통해 부여된 액세스를 차단할지 여부 (true/false)
    restrict_public_buckets = bool          # 퍼블릭 버킷을 제한할지 여부 (true/false)
    environment             = string        # 태그에 사용할 환경을 지정합니다 (예: "dev", "staging", "production").
  }))
  default = {} # 빈 값일 경우 버킷이 생성되지 않도록 합니다.
}

module "s3_buckets" {
  source = "./modules/s3"

  for_each               = var.s3_buckets
  bucket_name            = each.value.bucket_name
  enable_website_hosting = each.value.enable_website_hosting
  enable_cors            = each.value.enable_cors
  enable_public_access   = each.value.enable_public_access
  block_public_acls      = each.value.block_public_acls
  ignore_public_acls     = each.value.ignore_public_acls
  block_public_policy    = each.value.block_public_policy
  restrict_public_buckets = each.value.restrict_public_buckets
  environment            = each.value.environment
}

# Outputs
output "bucket_names" {
  description = "생성된 S3 버킷 이름 목록"
  value       = { for name, bucket in module.s3_buckets : name => bucket.bucket_name }
}

output "website_endpoints" {
  description = "정적 웹사이트 엔드포인트 목록 (정적 웹 호스팅이 활성화된 경우)"
  value       = { for name, bucket in module.s3_buckets : name => bucket.website_endpoint }
}