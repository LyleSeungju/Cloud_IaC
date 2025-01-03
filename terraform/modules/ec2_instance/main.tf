resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  
  root_block_device {
    volume_size = var.volume
    volume_type = "gp3"
  }
  tags = merge(var.tags, { Name = var.name })
}

