# 라우팅 테이블 모듈 변수 정의
variable "name" {
  description = "라우팅 테이블 이름"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "서브넷 ID 목록"
  type        = list(string)
}

variable "ipv4_routes" {
  description = "라우팅 테이블의 IPv4 경로 목록"
  type = list(object({
    cidr_block = string
    gateway_id = optional(string)
    nat_gateway_id = optional(string)
  }))
}