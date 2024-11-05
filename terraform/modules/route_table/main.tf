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