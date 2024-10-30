# 퍼블릭 서브넷
resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id                # VPC ID
  cidr_block              = var.public_subnet.cidr    # CIDR
  availability_zone       = var.public_subnet.az      # Availability Zone
  map_public_ip_on_launch = true                      # 서브넷에 생성된 인스턴스에 자동으로 퍼블릭 IP 할당 여부

  tags = {
    Name = var.public_subnet.name
  }
}


# 프라이빗 서브넷
resource "aws_subnet" "private" {
  for_each                = { for subnet in var.private_subnets : subnet.name => subnet }
  vpc_id                  = var.vpc_id      # VPC ID
  cidr_block              = each.value.cidr # CIDR
  availability_zone       = each.value.az   # Availability Zone
  map_public_ip_on_launch = true           # 서브넷에 생성된 인스턴스에 자동으로 퍼블릭 IP 할당 여부

  tags = {
    Name = each.value.name
  }
}