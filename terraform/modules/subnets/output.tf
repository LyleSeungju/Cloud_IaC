# 서브넷 ID 출력
output "subnet_id" {
  value       = aws_subnet.this.id
  description = "생성된 서브넷 ID"
}