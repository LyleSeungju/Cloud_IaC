output "rds_endpoint" {
  description = "RDS 엔드포인트 주소"
  value       = aws_db_instance.default.endpoint
}

output "rds_instance_id" {
  description = "RDS 인스턴스 ID"
  value       = aws_db_instance.default.id
}