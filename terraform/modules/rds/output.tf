# Outputs
output "rds_endpoint" {
  description = "RDS 인스턴스의 엔드포인트"
  value       = aws_db_instance.this.endpoint
}

output "rds_instance_id" {
  description = "RDS 인스턴스의 ID"
  value       = aws_db_instance.this.id
}