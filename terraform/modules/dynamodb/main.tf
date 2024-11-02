# variables.tf
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

# main.tf
resource "aws_dynamodb_table" "this" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.partition_key.name
  
  # 파티션 키 설정
  attribute {
    name = var.partition_key.name
    type = var.partition_key.type
  }

  # 정렬 키가 설정된 경우
  dynamic "attribute" {
    for_each = var.sort_key != null ? [var.sort_key] : []
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  range_key = var.sort_key != null ? var.sort_key.name : null

  tags = var.tags
}

# outputs.tf
output "table_name" {
  description = "생성된 DynamoDB 테이블 이름"
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "생성된 DynamoDB 테이블의 ARN"
  value       = aws_dynamodb_table.this.arn
}

output "table_id" {
  description = "생성된 DynamoDB 테이블 ID"
  value       = aws_dynamodb_table.this.id
}