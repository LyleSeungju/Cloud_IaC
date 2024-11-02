variable "name" {
  description = "VPC 이름"
  type        = string
}
variable "cidr_block" {
  description = "VPC의 CIDR 블록"
  type        = string
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
}


# VPC
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block # CIDR

  tags = { Name = var.name }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id   # VPC ID

  tags = { Name = "${var.name}-igw" }
}
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

