variable "vpc_id" {
  description = "VPC의 ID"
  type        = string
}

variable "name" {
  description = "보안 그룹 이름"
  type        = string
}

variable "ingress" {
  description = "인그레스 규칙"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
}

variable "egress" {
  description = "이그레스 규칙"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
}