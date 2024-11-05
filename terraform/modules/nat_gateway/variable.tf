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