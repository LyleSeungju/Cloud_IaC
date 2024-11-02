output "instances_info" {
  value = {
    for instance_name, instance in module.ec2_instance : instance_name => {
      instance_id       = instance.instance_id
      private_ip        = instance.instance_private_ip
      public_ip         = instance.instance_public_ip
    }
  }
  description = "각 인스턴스 이름에 따른 EC2 인스턴스 정보 (ID, 사설 IP, 공인 IP)"
}

output "rds_endpoint" {
  description = "RDS 인스턴스의 엔드포인트"
  value       = var.is_rds && length(module.rds) > 0 ? module.rds[0].rds_endpoint : null
}

output "ecr_repository_urls" {
  description = "각 ECR 리포지토리의 URL 목록"
  value       = { for repo_name, repo in module.ecr.repository_urls : repo_name => repo }
}

output "dynamodb_tables_info" {
  description = "생성된 DynamoDB 테이블 정보 목록"
  value = {
    for table_name, table in module.dynamodb_tables :
    table_name => {
      table_name = table.table_name
      table_arn  = table.table_arn
      table_id   = table.table_id
    }
  }
}