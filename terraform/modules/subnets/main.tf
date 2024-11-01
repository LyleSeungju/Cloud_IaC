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

variable "subnets" {
  description = "서브넷 정보 맵"
  type = map(object({
    cidr_block           = string
    availability_zone = string
  }))
}

# 서브넷 생성
resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = "${var.name}-${each.key}"
  }
}

# 서브넷 ID 출력
output "subnet_ids" {
  value       = { for key, subnet in aws_subnet.this : key => subnet.id }
  description = "생성된 서브넷 ID 목록 (서브넷 이름별)"
}