variable "name" {
  description = "NAT 게이트웨이 이름"
  type        = string
}

variable "enabled" {
  description = "NAT 게이트웨이 생성 여부"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "퍼블릭 서브넷 ID (NAT 게이트웨이를 배치할 서브넷)"
  type        = string
}

resource "aws_eip" "nat_eip" {
  count = var.enabled ? 1 : 0

  tags = {
    Name = "${var.name}-eip"
  }
}

resource "aws_nat_gateway" "this" {
  count         = var.enabled ? 1 : 0
  allocation_id = var.enabled ? aws_eip.nat_eip[0].id : null
  subnet_id     = var.subnet_id

  tags = {
    Name = "${var.name}"
  }
}

# NAT 게이트웨이 ID 출력
output "nat_id" {
  value       = var.enabled ? aws_nat_gateway.this[0].id : null
  description = "생성된 NAT 게이트웨이의 ID"
}