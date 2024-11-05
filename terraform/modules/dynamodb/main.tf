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
