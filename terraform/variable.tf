# AWS Region
variable "region" {
  description = "AWS 리전"
  type        = string
}


# VPC
variable "vpc_cidr" {
  description = "VPC의 CIDR 블록"
  type        = string
}

variable "vpc_name" {
  description = "VPC 이름"
  type        = string
}


# IGW
variable "igw_name" {
  description = "인터넷 게이트웨이 이름"
  type        = string
}
# NAT gateway
variable "nat_name" {
  description = "NAT 게이트웨이 이름"
  type        = string
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
}

variable "private_route_table_name" {
  description = "프라이빗 라우트 테이블 이름"
  type        = string
}


# Security Groups
variable "sg_name" {
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


# EC2
variable "ami" {
  description = "인스턴스의 AMI ID"
  type        = string
}

variable "instance_type" {
  description = "인스턴스 유형"
  type        = string
}

variable "key_name" {
  description = "SSH 키 이름"
  type        = string
}

variable "instance_public_count" {
  description = "퍼블릭 인스턴스의 수"
  type        = number
}

variable "instance_private_count" {
  description = "프라이빗 인스턴스의 수"
  type        = number
}


# RDS
variable "rds_count" {
  description = "RDS 생성 여부"
  type = number
}

variable "rds_name" {
  description = "RDS 이름"
  type        = string
}

variable "allocated_storage" {
  description = "RDS의 초기 스토리지 크기"
  type        = number
}

variable "db_name" {
  description = "RDS 데이터베이스 이름"
  type        = string
}

variable "engine" {
  description = "RDS 엔진 종류"
  type        = string
}

variable "engine_version" {
  description = "RDS 엔진 버전"
  type        = string
}

variable "instance_class" {
  description = "RDS 인스턴스 클래스"
  type        = string
}

variable "username" {
  description = "RDS 관리자 사용자 이름"
  type        = string
}

variable "password" {
  description = "RDS 관리자 비밀번호"
  type        = string
  sensitive   = true
}

variable "parameter_group_name" {
  description = "RDS 파라미터 그룹 이름"
  type        = string
}

variable "skip_final_snapshot" {
  description = "삭제 시 최종 스냅샷 생성 여부"
  type        = bool
}

variable "max_allocated_storage" {
  description = "RDS 자동 확장 최대 스토리지"
  type        = number
}