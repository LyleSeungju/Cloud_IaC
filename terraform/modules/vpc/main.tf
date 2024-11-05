# VPC
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block # CIDR
  tags = { Name = var.name }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id   # VPC ID

  tags = { Name = "${var.name}-igw" }
}

