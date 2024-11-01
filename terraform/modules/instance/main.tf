variable "name" {
  description = "인스턴스 이름"
  type        = string
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
}

variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "subnet_id" {
  description = "서브넷 ID"
  type        = string
}

variable "security_group_ids" {
  description = "보안 그룹 ID 목록"
  type        = list(string)
}

variable "tags" {
  description = "태그 목록"
  type        = map(string)
  default     = {}
}

resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  tags                   = merge(var.tags, { Name = var.name })

  # 필요에 따라 추가 설정
}

# 인스턴스 ID 출력
output "instance_id" {
  value       = aws_instance.this.id
  description = "생성된 EC2 인스턴스 ID"
}

output "instance_private_ip" {
  value       = aws_instance.this.private_ip
  description = "인스턴스의 사설 IP 주소"
}

output "instance_public_ip" {
  value       = aws_instance.this.public_ip
  description = "인스턴스의 공인 IP 주소 (있는 경우)"
}

# resource "aws_instance" "public" {
#   count                  = var.instance_public_count    # 인스턴스 개수
#   ami                    = var.ami                      # Amazon EC2 이미지
#   instance_type          = var.instance_type            # 인스턴스 유형
#   key_name               = var.key_name                 # 인스턴스 접속 키
#   subnet_id              = var.public_subnet_id         # 서브넷 ID
#   associate_public_ip_address = true                    # 퍼블릭 IP 자동 할당
#   vpc_security_group_ids = [var.security_group_id]      # VPC에 소속된 보안그룹

#   tags = {
#     Name = "terraform-public-instance-${count.index}"
#   }
# }

# resource "aws_instance" "private" {
#   count                  = var.instance_private_count   # 인스턴스 개수
#   ami                    = var.ami                      # Amazon EC2 이미지
#   instance_type          = var.instance_type            # 인스턴스 유형
#   key_name               = var.key_name                 # 인스턴스 접속키
#   subnet_id              = var.private_subnet_id         # 프라이빗 서브넷
#   vpc_security_group_ids = [var.security_group_id]      # VPC 소속된 보안그룹

#   tags = {
#     Name = "terraform-private-instance-${count.index}"
#   }
# }