output "public_route_table_id" {
  description = "퍼블릭 라우트 테이블의 ID"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "프라이빗 라우트 테이블의 ID"
  value       = aws_route_table.private.id
}