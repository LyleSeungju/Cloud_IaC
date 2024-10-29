# VPC
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block # CIDR

  tags = {
    Name = var.name
  }
}