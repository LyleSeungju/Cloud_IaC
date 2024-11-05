#!/bin/bash

# Terraform 초기화, 유효성 검사, 계획 생성
terraform init
terraform validate
terraform plan -var-file="main.tfvars" -out=planfile

if [ $? -ne 0 ]; then
  echo "Error: Terraform plan failed."
  exit 1
fi

# Terraform 적용
terraform apply -auto-approve planfile

# Terraform 출력 값을 JSON 형식으로 저장
terraform output -json > terraform_output.json

# Ansible 디렉토리로 이동
cd ../ansible

if [ $? -ne 0 ]; then
  echo "Error: ../ansible 디렉토리를 찾을 수 없습니다."
  exit 1
fi

# Ansible 인벤토리 파일 생성
cat <<EOF > inventory.ini
EOF

# `terraform_output.json`의 각 출력 항목을 동적으로 처리
function add_to_hosts_ini() {
  local section_name=$1
  local entries=$2
  local key_var=$3
  local value_var=$4
  echo "[$section_name]" >> inventory.ini
  echo "$entries" | jq -r 'to_entries[] | "\(.key)=\(.value)"' >> inventory.ini
  echo "" >> inventory.ini
}

# bucket_names 출력 처리
bucket_names=$(jq -r '.bucket_names.value' terraform_output.json)
if [ "$bucket_names" != "null" ] && [ "$bucket_names" != "{}" ]; then
  add_to_hosts_ini "s3_buckets" "$bucket_names" "bucket_name" "bucket_value"
fi

# dynamodb_tables_info 출력 처리
dynamodb_tables=$(jq -r '.dynamodb_tables_info.value' terraform_output.json)
if [ "$dynamodb_tables" != "null" ] && [ "$dynamodb_tables" != "{}" ]; then
  add_to_hosts_ini "dynamodb_tables" "$dynamodb_tables" "table_name" "table_info"
fi

# ecr_repository_urls 출력 처리
ecr_repositories=$(jq -r '.ecr_repository_urls.value' terraform_output.json)
if [ "$ecr_repositories" != "null" ] && [ "$ecr_repositories" != "{}" ]; then
  add_to_hosts_ini "ecr_repositories" "$ecr_repositories" "repo_name" "repo_url"
fi

# instances_info 출력 처리
instances_info=$(jq -r '.instances_info.value' terraform_output.json)
if [ "$instances_info" != "null" ] && [ "$instances_info" != "{}" ]; then
  echo "[instances_info]" >> inventory.ini
  echo "$instances_info" | jq -r 'to_entries[] | "\(.key) public_ip=\(.value.public_ip) private_ip=\(.value.private_ip) instance_id=\(.value.instance_id)"' >> hosts.ini
  echo "" >> inventory.ini
fi

# website_endpoints 출력 처리
website_endpoints=$(jq -r '.website_endpoints.value' terraform_output.json)
if [ "$website_endpoints" != "null" ] && [ "$website_endpoints" != "{}" ]; then
  add_to_hosts_ini "website_endpoints" "$website_endpoints" "bucket_name" "endpoint"
fi

# rds_endpoint 출력 처리
rds_endpoint=$(jq -r '.rds_endpoint.value' terraform_output.json)
if [ "$rds_endpoint" != "null" ]; then
  echo "[rds_endpoint]" >> inventory.ini
  echo "endpoint=$rds_endpoint" >> inventory.ini
  echo "" >> inventory.ini
fi

echo "inventory.ini 파일이 ../ansible 디렉토리에 생성되었습니다."
