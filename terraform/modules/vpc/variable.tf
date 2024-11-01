variable "name" {
  description = "VPC 이름"
  type        = string
}
variable "cidr_block" {
  description = "VPC의 CIDR 블록"
  type        = string
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
}
