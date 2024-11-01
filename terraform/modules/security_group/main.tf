# modules/security_group/main.tf

variable "name" {
  description = "보안 그룹 이름"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ingress_rules" {
  description = "인바운드 규칙 목록"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "아웃바운드 규칙 목록"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "tags" {
  description = "태그 목록"
  type        = map(string)
  default     = {}
}

resource "aws_security_group" "this" {
  name   = var.name
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = var.name })

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

# 보안 그룹 ID 출력 (이름별로 출력)
output "security_group_id" {
  value       = aws_security_group.this.id
  description = "생성된 보안 그룹 ID"
}
