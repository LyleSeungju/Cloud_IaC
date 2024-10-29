# 퍼블릭 라우팅 테이블 
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

# 퍼블릭 라우팅 테이블에 서브넷 연결
resource "aws_route_table_association" "public" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.public.id
}


# 프라이빗 라우팅 테이블
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block    = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = var.private_route_table_name
  }
}

# 프라이빗 라우팅 테이블에 서브넷 연결
resource "aws_route_table_association" "private" {
  for_each      = { for idx, id in var.private_subnet_ids : idx => id }
  subnet_id     = each.value
  route_table_id = aws_route_table.private.id
}