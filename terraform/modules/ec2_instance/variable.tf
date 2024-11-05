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