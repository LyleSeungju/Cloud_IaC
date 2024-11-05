# 보안 그룹 ID 출력 (이름별로 출력)
output "security_group_id" {
  value       = aws_security_group.this.id
  description = "생성된 보안 그룹 ID"
}