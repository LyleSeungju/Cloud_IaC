resource "aws_nat_gateway" "this" {
  count         = var.enabled ? 1 : 0
  allocation_id = var.enabled ? aws_eip.nat_eip[0].id : null
  subnet_id     = var.subnet_id

  tags = {
    Name = "${var.name}"
  }
}