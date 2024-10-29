output "nat_gateway_id" {
  description = "NAT 게이트웨이의 ID"
  value       = aws_nat_gateway.this.id
}

output "eip_public_ip" {
  description = "NAT 게이트웨이의 퍼블릭 IP"
  value       = aws_eip.this.public_ip
}