variable "vpc_id" {
  description = "VPC의 ID"
  type        = string
}

variable "public_subnet" {
  description = "퍼블릭 서브넷 설정"
  type = object({
    cidr = string
    az   = string
    name = string
  })
}

variable "private_subnets" {
  description = "프라이빗 서브넷 설정"
  type = list(object({
    cidr = string
    az   = string
    name = string
  }))
}