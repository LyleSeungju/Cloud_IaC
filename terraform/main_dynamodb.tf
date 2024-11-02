variable "dynamodb_tables" {
  description = "DynamoDB 테이블 설정 목록"
  type = list(object({
    table_name    = string
    partition_key = object({
      name = string
      type = string
    })
    sort_key = optional(object({
      name = string
      type = string
    }))
    tags = optional(map(string))
  }))
  default = []
}

module "dynamodb_tables" {
  source      = "./modules/dynamodb"
  for_each    = { for table in var.dynamodb_tables : table.table_name => table }
  table_name  = each.value.table_name
  partition_key = each.value.partition_key
  sort_key      = lookup(each.value, "sort_key", null)
  tags          = lookup(each.value, "tags", {})
}