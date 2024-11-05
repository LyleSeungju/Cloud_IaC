# 라우팅 테이블 ID 출력
output "rtb_id" {
  value       = aws_route_table.this.id
  description = "생성된 라우팅 테이블의 ID"
}