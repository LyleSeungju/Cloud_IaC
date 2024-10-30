# AWS Region
variable "region" {
  description = "AWS 리전"
  type        = string
}


# VPC
variable "vpc_cidr" {
  description = "VPC의 CIDR 블록"
  type        = string
  default     = "192.168.0.0/16"
}
variable "vpc_name" {
  description = "VPC 이름"
  type        = string
  default     = "terraform-vpc"
}


# IGW
variable "igw_name" {
  description = "인터넷 게이트웨이 이름"
  type        = string
  default     = "terraform-igw"
}

# NAT gateway
variable "nat_name" {
  description = "NAT 게이트웨이 이름"
  type        = string
  default     = "terraform-nat"
}
variable "nat_count" {
  description = "NAT 게이트웨이 갯수"
  type        = number
  default     = 1
}

# Subnets
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


# Route Tables
variable "public_route_table_name" {
  description = "퍼블릭 라우트 테이블 이름"
  type        = string
  default     = "terraform_rtb_public"
}

variable "private_route_table_name" {
  description = "프라이빗 라우트 테이블 이름"
  type        = string
  default     = "terraform_rtb_private"
}


# Security Groups
variable "sg_name" {
  description = "보안 그룹 이름"
  type        = string
}

variable "ingress" {
  description = "인바운드 규칙"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
}

variable "egress" {
  description = "아웃바운드 규칙"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
}





