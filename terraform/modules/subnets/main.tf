variable "name" {
  description = "서브넷 그룹의 이름"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "퍼블릭 IP 자동 할당 여부"
  type        = bool
}

variable "cidr_block" {
  description = "서브넷 CIDR 블록"
  type        = string
}

variable "availability_zone" {
  description = "서브넷의 가용 영역"
  type        = string
}

# 서브넷 생성
resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.name}"
  }
}

# 서브넷 ID 출력
output "subnet_id" {
  value       = aws_subnet.this.id
  description = "생성된 서브넷 ID"
}