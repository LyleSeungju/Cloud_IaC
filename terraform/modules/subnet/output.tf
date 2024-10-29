output "public_subnet_id" {
  description = "퍼블릭 서브넷의 ID"
  value       = aws_subnet.public.id
}

output "private_subnet_ids" {
  description = "프라이빗 서브넷들의 ID"
  value       = [for subnet in aws_subnet.private : subnet.id]
}