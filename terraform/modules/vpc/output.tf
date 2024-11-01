output "name" {
  value = var.name
  description = "VPC의 이름"
}

# Output VPC ID
output "vpc_id" {
  value       = aws_vpc.this.id
  description = "생성된 VPC의 ID"
}

# Output Internet Gateway ID
output "internet_gateway_id" {
  value       = aws_internet_gateway.this.id
  description = "생성된 인터넷 게이트웨이의 ID"
}
