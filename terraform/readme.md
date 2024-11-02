
# Lyle 테라폼  모듈화 사용 설명서 

### 테라폼 실행 순서

#### 인프라 프로비저닝 시작
1. 테라폼 초기화: `terraform init` 
2. 테라폼 유효성 검사: `terraform validate`
3. 테라폼 실행 계획: `terraform plan -var-file="main.tfvars" -out=planfile`
4. 테라폼 실행: `terraform apply -auto-approve planfile`
5. 프로비저닝된 결과 파일 저장: `terraform output -json > terraform_output.json`

#### 인프라 추가 계획 반영
1. `terraform init` : 새로운 모듈이 추가되었을 때 실행
2. `terraform plan -var-file="main.tfvars" -out=planfile`
3. `terraform apply -auto-approve planfile` 

#### 인프라 최신 정보 반영
`terraform refresh` : 인프라의 현재 상태를 반영

#### 인프라 삭제
 `terraform destroy -var-file="main.tfvars"` : 모든 리소스 삭제

---
### 참고사항
> 아래는 각 서비스별 테라폼 메인 코드에 설정된 요소입니다. 파일명은 각 변수와 연관되어 있음을 참고하며, 실제 변수값은 main.tfvars 파일에 입력합니다.

- [VPC 설정](#vpc-설정)
- [서브넷 설정](#서브넷-설정)
- [보안 그룹 설정](#보안-그룹-설정)
- [EC2 인스턴스](#ec2-인스턴스)
- [RDS 데이터베이스](#rds-설정) (선택 사항)
- [S3 버킷](#s3-설정) (선택 사항)
- [ECR 리포지토리](#ecr-설정) (선택 사항)
- [DynamoDB 테이블](#dynamodb-설정) (선택 사항)

---
# VPC 

#### main_vpc.tf
입력값
```
region = "us-east-1" # 리전 설정

vpc_config = {
  name       = "custom-vpc" # 서비스의 이름을 지정 - 이것이 모든 요소의 기준이 됨
  cidr_block = "10.0.0.0/16" # VPC의 CIDR 블록 설정
}


nat = {
  enabled            = true        # NAT Gateway 사용 여부를 설정
  public_subnet_name = "public1"   # NAT Gateway가 위치할 퍼블릭 서브넷의 이름을 지정

}
```

생성 요소 
- VPC: custom-vpc-vpc
- NAT Gateway: custom-vpc-nat
- 퍼블릭 라우트 테이블: custom-vpc-rtb-public
- 프라이빗 라우트 테이블: custom-vpc-rtb-private

#### main_vpc_subnet.tf
입력값
```
public_subnets = { # 여러 개 설정 가능
  "public1" = {
    cidr_block        = "192.168.1.0/24"    # 퍼블릭 서브넷의 CIDR 블록
    availability_zone = "ap-northeast-2a"   # 가용 영역
  }
  "public2" = {
    cidr_block        = "192.168.2.0/24"   
    availability_zone = "ap-northeast-2b"   
  }
}

private_subnets = { # 여러 개 설정 가능
  "private1" = {
    cidr_block        = "192.168.3.0/24"    # 프라이빗 서브넷의 CIDR 블록
    availability_zone = "ap-northeast-2a"   # 가용 영역
  }
  "private2" = {
    cidr_block        = "192.168.4.0/24"    
    availability_zone = "ap-northeast-2b"   
  }
}
```

생성 요소 
- 퍼블릭 서브넷 1: custom-vpc-subnet-public1
- 퍼블릭 서브넷 2: custom-vpc-subnet-public2
- 프라이빗 서브넷 1: custom-vpc-subnet-private1
- 프라이빗 서브넷 2: custom-vpc-subnet-private2

#### main_vpc_sq.tf
입력값
```
sg = [
  {
    name    = "web-sg"                    # 보안 그룹 이름
    ingress = [
      {
        from_port   = 80                   # 인바운드
        to_port     = 80                   
        protocol    = "tcp"                # 프로토콜 (TCP)
        cidr_blocks = ["0.0.0.0/0"]        # 모든 IP 주소에서 접근 허용
      },
      {
        from_port   = 443                  
        to_port     = 443                  
        protocol    = "tcp"                
        cidr_blocks = ["0.0.0.0/0"]        
      }
    ]
    egress = [
      {
        from_port   = 0                    # 아웃바운드
        to_port     = 0                    
        protocol    = "-1"                 # 모든 프로토콜 허용
        cidr_blocks = ["0.0.0.0/0"]        
      }
    ]
  }
]
```

생성 요소 
- 보안 그룹 웹 서비스용: custom-vpc-sg-web-sg
- 보안 그룹 데이터베이스용: custom-vpc-sg-db-sg
---

# EC2 Instance
#### main_ec2_instance.tf
입력값
```
instances = [
  {
    name                 = "web-service"                  # EC2 인스턴스 이름
    ami                  = "ami-02c329a4b4aba6a48"        # AMI ID
    instance_type        = "t3.micro"                     # 인스턴스 유형 
    volume               = 10                             # 볼륨 크기 (GB) (Default: 8GB)
    is_public            = true                           # 퍼블릭 서브넷 배치 여부 (퍼블릭: true, 프라이빗: false)
    subnet_name          = "public1"                      # 배치할 서브넷 이름 (퍼블릭 인스턴스 - 퍼블릭 서브넷 형식 맞출 것)
    security_group_names = ["web-sg", "db-sg"]            # 연결할 보안 그룹 이름 목록
  },
]
```

생성 요소 
- EC2 인스턴스: custom-vpc-instance-web-service

---
# RDS  (선택 사항)
#### main_rds.tf
입력값
```
# RDS 인스턴스 생성 여부 및 설정
is_rds = true  # RDS 인스턴스를 생성할지 여부

rds_config = {
  rds_name              = "my-rds-instance"       # 생성할 RDS 인스턴스 이름
  allocated_storage     = 20                      # 초기 할당된 스토리지 크기 (GB)
  max_allocated_storage = 100                     # 자동 확장 시 최대 스토리지 크기 (GB)
  db_name               = "mydatabase"            # 데이터베이스 이름
  engine                = "mysql"                 # RDS 엔진 (예: mysql)
  engine_version        = "8.0.23"                # RDS 엔진 버전
  instance_class        = "db.t3.micro"           # RDS 인스턴스 유형
  username              = "admin"                 # 데이터베이스 관리자 사용자 이름
  password              = "password123"           # 데이터베이스 관리자 비밀번호 (중요 정보로 직접 깃에 올리지 않도록 주의)
  security_group_names  = []                      # 보안 그룹 이름은 자동으로 설정되므로 빈 리스트
  skip_final_snapshot   = true                    # 인스턴스 삭제 시 최종 스냅샷 건너뛰기
}

# 가시성을 위해 RDS용 보안그룹 따로 구성
rds_sg = [ 
  { 
    name    = "rds-db"                            # RDS 전용 보안 그룹 이름
    ingress = [
      {
        from_port   = 3306                        # 인바운드 포트 
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"]             # 허용할 IP 범위 
      }
    ]
    egress = [
      {
        from_port   = 0                           # 아웃바운드 모든 트래픽 허용
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
]
```

생성 요소 
> RDS 이름은 독립적으로 설정하게끔 의도 (VPC 이름과 상관 없음)
- RDS 인스턴스 이름: my-rds-instance
- RDS 보안 그룹: custom-vpc-sg-rds-db

---
# S3  (선택 사항)
#### main_s3.tf
입력값
```
s3_buckets = {
  bucket1 = {
    bucket_name             = "my-example-bucket-1"       # S3 버킷의 이름을 지정
    enable_website_hosting  = true                        # 정적 웹사이트 호스팅을 활성화할지 여부 (true/false)
    enable_cors             = true                        # CORS 설정을 활성화할지 여부 (true/false)
    enable_public_access    = false                       # 퍼블릭 접근을 허용할지 여부 (true/false)
    block_public_acls       = true                        # 퍼블릭 ACL을 통해 부여된 액세스를 차단할지 여부 (true/false)
    ignore_public_acls      = true                        # 퍼블릭 ACL을 무시할지 여부 (true/false)
    block_public_policy     = true                        # 퍼블릭 정책을 통해 부여된 액세스를 차단할지 여부 (true/false)
    restrict_public_buckets = true                        # 퍼블릭 버킷을 제한할지 여부 (true/false)
    environment             = "production"                # 태그
  },
}
```

생성 요소 
> S3 이름은 독립적으로 설정하게끔 의도 (VPC 이름과 상관 없음)
- S3 버킷 이름: my-example-bucket-1
- 정적 웹사이트 엔드포인트: 활성화된 경우, 각 버킷별로 정적 웹사이트 URL 제공

---

# ECR  (선택 사항)
#### main_ecr.tf
입력값
```
is_ecr = true  # ECR 리포지토리 생성 여부 설정

ecr_repositories = [
  {
    name                   = "repo1"                # ECR 리포지토리의 이름을 지정
    image_tag_mutability   = "IMMUTABLE"           # 이미지 태그 변경 가능 여부 ("IMMUTABLE" 또는 "MUTABLE")
    image_scanning_enabled = true                  # 이미지 스캔 활성화 여부
    lifecycle_policy       = true                  # 라이프사이클 정책 활성화 여부. true이면 기본 정책 적용 (30일 후 언태그된 이미지 삭제)
    tags = {                                       # 리포지토리에 추가할 태그 목록
      Environment = "production"
      Project     = "MyProject"
    }
  },
]
```

생성 요소 
> ECR 이름은 독립적으로 설정하게끔 의도 (VPC 이름과 상관 없음)
- ECR 리포지토리 이름: repo1
- 이미지 태그 변경 불가 여부: IMMUTABLE (변경 불가) 또는 MUTABLE (변경 가능)
- 이미지 스캔: 활성화된 경우 스캔을 통해 취약성 검사 가능
- 라이프사이클 정책: true인 경우 30일 후 언태그된 이미지 삭제
- 태그: 각 리포지토리에 지정된 환경 및 프로젝트 태그 포함

---
# DynamoDB  (선택 사항)
#### main_dynamodb.tf
입력값
```
dynamodb_tables = [
  {
    table_name    = "UserTable"                  # DynamoDB 테이블 이름 지정
    partition_key = {                            # 파티션 키 설정
      name = "UserId"                            # 파티션 키의 이름 (예: "UserId")
      type = "S"                                 # 파티션 키의 유형 (예: "S" - 문자열, "N" - 숫자)
    }
    sort_key = {                                 # 정렬 키 설정 (선택 사항)
      name = "CreatedDate"                       # 정렬 키의 이름 (예: "CreatedDate")
      type = "S"                                 # 정렬 키의 유형 (예: "S" - 문자열, "N" - 숫자)
    }
    tags = {                                     # 테이블에 추가할 태그 목록
      Environment = "production"
      Project     = "UserManagement"
    }
  },
  {
    table_name    = "ProductTable"
    partition_key = {
      name = "ProductId"
      type = "S"
    }
    # 정렬 키 생략 가능
    tags = {
      Environment = "staging"
      Project     = "ProductCatalog"
    }
  }
]

```

생성 요소 
> DynamoDB 이름은 독립적으로 설정하게끔 의도 (VPC 이름과 상관 없음)
- DynamoDB 테이블 이름: UserTable, ProductTable
- 파티션 키: 각 테이블의 주요 키 설정
- 정렬 키 (선택 사항): 필요시 정렬 키 추가 가능
- 태그: 각 테이블에 추가할 환경 및 프로젝트 태그 포함
--- 
# 출력값(예시)
```
{
  "instances_info": {
    "web-service": {
      "instance_id": "i-0abc123def4567890",
      "private_ip": "192.168.1.150",
      "public_ip": "13.125.61.202"
    },
    "db-service": {
      "instance_id": "i-0xyz123uvw4567890",
      "private_ip": "192.168.3.25",
      "public_ip": "15.165.18.135"
    }
  },
  "rds_endpoint": "my-rds-instance.cz0oi80og7ce.ap-northeast-2.rds.amazonaws.com:3306",
  "ecr_repository_urls": {
    "repo1": "123456789012.dkr.ecr.us-east-1.amazonaws.com/repo1",
    "repo2": "123456789012.dkr.ecr.us-east-1.amazonaws.com/repo2"
  },
  "dynamodb_tables_info": {
    "UserTable": {
      "table_name": "UserTable",
      "table_arn": "arn:aws:dynamodb:us-east-1:123456789012:table/UserTable",
      "table_id": "12345678-abcd-1234-efgh-5678ijklmnop"
    },
    "ProductTable": {
      "table_name": "ProductTable",
      "table_arn": "arn:aws:dynamodb:us-east-1:123456789012:table/ProductTable",
      "table_id": "abcdefgh-1234-ijkl-5678-mnopqrstuvwxyz"
    }
  }
}
```
