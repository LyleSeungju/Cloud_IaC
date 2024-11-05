variable "table_name" {
  description = "DynamoDB 테이블 이름"
  type        = string
}

variable "partition_key" {
  description = "DynamoDB 테이블의 파티션 키 이름 및 유형"
  type = object({
    name = string
    type = string
  })
}

variable "sort_key" {
  description = "DynamoDB 테이블의 정렬 키 (선택 사항)"
  type = object({
    name = string
    type = string
  })
  default = null
}

variable "tags" {
  description = "DynamoDB 테이블에 적용할 태그"
  type        = map(string)
  default     = {}
}
