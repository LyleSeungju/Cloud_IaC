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

# 라우팅 테이블 생성
resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  # 라우팅 테이블 경로 설정
  dynamic "route" {
    for_each = var.ipv4_routes
    content {
      cidr_block     = route.value.cidr_block
      gateway_id     = try(route.value.gateway_id, null)
      nat_gateway_id = try(route.value.nat_gateway_id, null)
    }
  }

  tags = {
    Name = var.name
  }
}

# 서브넷에 라우팅 테이블 연결
resource "aws_route_table_association" "this" {
  count = length(var.subnets)

  route_table_id = aws_route_table.this.id
  subnet_id      = var.subnets[count.index]
}

# 라우팅 테이블 ID 출력
output "route_table_id" {
  value       = aws_route_table.this.id
  description = "생성된 라우팅 테이블의 ID"
}