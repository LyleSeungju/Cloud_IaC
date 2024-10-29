resource "aws_instance" "public" {
  count                  = var.instance_public_count    # 인스턴스 개수
  ami                    = var.ami                      # Amazon EC2 이미지
  instance_type          = var.instance_type            # 인스턴스 유형
  key_name               = var.key_name                 # 인스턴스 접속 키
  subnet_id              = var.public_subnet_id         # 서브넷 ID
  associate_public_ip_address = true                    # 퍼블릭 IP 자동 할당
  vpc_security_group_ids = [var.security_group_id]      # VPC에 소속된 보안그룹

  tags = {
    Name = "terraform-public-instance-${count.index}"
  }
}

resource "aws_instance" "private" {
  count                  = var.instance_private_count   # 인스턴스 개수
  ami                    = var.ami                      # Amazon EC2 이미지
  instance_type          = var.instance_type            # 인스턴스 유형
  key_name               = var.key_name                 # 인스턴스 접속키
  subnet_id              = element(var.private_subnet_ids, count.index % length(var.private_subnet_ids))  # 서브넷 ID
  vpc_security_group_ids = [var.security_group_id]      # VPC 소속된 보안그룹

  tags = {
    Name = "terraform-private-instance-${count.index}"
  }
}