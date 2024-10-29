output "security_group_id" {
  description = "보안 그룹의 ID"
  value       = aws_security_group.this.id
}