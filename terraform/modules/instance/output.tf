output "public_instance_ids" {
  description = "퍼블릭 인스턴스들의 ID"
  value       = [for instance in aws_instance.public : instance.id]
}

output "private_instance_ids" {
  description = "프라이빗 인스턴스들의 ID"
  value       = [for instance in aws_instance.private : instance.id]
}

output "public_instance_ips" {
  description = "퍼블릭 인스턴스들의 IP"
  value       = [for instance in aws_instance.public : instance.public_ip]
}

output "private_instance_ips" {
  description = "프라이빗 인스턴스들의 IP"
  value       = [for instance in aws_instance.private : instance.private_ip]
}