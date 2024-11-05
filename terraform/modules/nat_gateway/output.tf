# NAT 게이트웨이 ID 출력
output "nat_id" {
  value       = var.enabled ? aws_nat_gateway.this[0].id : null
  description = "생성된 NAT 게이트웨이의 ID"
}