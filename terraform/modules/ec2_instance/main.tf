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

variable "volume" {
  description = "루트 볼륨 크기(GB 단위)"
  type = number
  default = 8
}

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
