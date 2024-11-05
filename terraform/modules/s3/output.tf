output "bucket_name" {
  description = "생성된 S3 버킷 이름"
  value       = aws_s3_bucket.this.bucket
}

# 정적 웹사이트 호스팅이 활성화된 경우에만 출력
output "website_endpoint" {
  description = "정적 웹사이트 엔드포인트 (정적 웹 호스팅이 활성화된 경우)"
  value       = length(aws_s3_bucket_website_configuration.this) > 0 ? aws_s3_bucket_website_configuration.this[0].website_endpoint : null
}