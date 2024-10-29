resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name = var.name
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id    # 탄력적 IP ID
  subnet_id     = var.subnet_id      # 서브넷 ID

  tags = {
    Name = var.name
  }
}