# EC2
variable "ami" {
  description = "인스턴스의 AMI ID"
  type        = string
  default     = "ami-02c329a4b4aba6a48" # Amazon Linux 2023
}

variable "instance_type" {
  description = "인스턴스 유형"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH 키 이름"
  type        = string
}

variable "instance_public_count" {
  description = "퍼블릭 인스턴스의 수"
  type        = number
  default     = 1
}

variable "instance_private_count" {
  description = "프라이빗 인스턴스의 수"
  type        = number
  default     = 1
}