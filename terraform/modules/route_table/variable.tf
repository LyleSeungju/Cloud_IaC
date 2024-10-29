variable "vpc_id" {
  description = "VPC의 ID"
  type        = string
}

variable "gateway_id" {
  description = "인터넷 게이트웨이의 ID"
  type        = string
}

variable "public_subnet_id" {
  description = "퍼블릭 서브넷의 ID"
  type        = string
}

variable "nat_gateway_id" {
  description = "NAT 게이트웨이의 ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "프라이빗 서브넷들의 ID"
  type        = list(string)
}

variable "public_route_table_name" {
  description = "퍼블릭 라우트 테이블 이름"
  type        = string
}

variable "private_route_table_name" {
  description = "프라이빗 라우트 테이블 이름"
  type        = string
}