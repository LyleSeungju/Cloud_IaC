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