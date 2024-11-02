# 지역 설정
region = "ap-northeast-2"

vpc_config = {
    name       = "terraform-test"
    cidr_block = "192.168.0.0/16"
}

# Subnet
public_subnets = {
    "public1" = {
        cidr_block        = "192.168.1.0/24"
        availability_zone = "ap-northeast-2a"
    },
    "public2" = {
        cidr_block        = "192.168.2.0/24"
        availability_zone = "ap-northeast-2b"
    }
}
private_subnets = {
    "private1" = {
        cidr_block        = "192.168.3.0/24"
        availability_zone = "ap-northeast-2a"
    }
    "private2" = {
        cidr_block        = "192.168.4.0/24"
        availability_zone = "ap-northeast-2b"
    }
}


# NAT gateway
# 사용하지 않으면 enabled = false
nat = {
    enabled            = true
    public_subnet_name = "public1"
}

# Security Groups
# 사용하지 않으면: sg = []
sg = [
  # { 
  #   name    = "web-unique"
  #   ingress = [
  #     {
  #       from_port   = 80
  #       to_port     = 80
  #       protocol    = "tcp"
  #       cidr_blocks = ["0.0.0.0/0"]
  #     },
  #     {
  #       from_port   = 443
  #       to_port     = 443
  #       protocol    = "tcp"
  #       cidr_blocks = ["0.0.0.0/0"]
  #     }
  #   ]
  #   egress = [
  #     {
  #       from_port   = 0
  #       to_port     = 0
  #       protocol    = "-1"
  #       cidr_blocks = ["0.0.0.0/0"]
  #     }
  #   ]
  # },
  # { 
  #   name    = "db-unique"
  #   ingress = [
  #     {
  #       from_port   = 3306
  #       to_port     = 3306
  #       protocol    = "tcp"
  #       cidr_blocks = ["10.0.0.0/16"]
  #     }
  #   ]
  #   egress = [
  #     {
  #       from_port   = 0
  #       to_port     = 0
  #       protocol    = "-1"
  #       cidr_blocks = ["0.0.0.0/0"]
  #     }
  #   ]
  # }
]

# EC2
# 사용하지 않으면: intances = []
instances = [
  # {
  #   name                 = "web-service"
  #   ami                  = "ami-062cf18d655c0b1e8"
  #   instance_type        = "t3.micro"
  #   volume               = 10
  #   is_public            = true # 퍼블릭 인스턴스일때 true / 프라이빗 인스턴스일때 false
  #   subnet_name          = "public1"
  #   security_group_names = ["web-unique", "db-unique"]
  # },
  # {
  #   name                 = "db-service"
  #   ami                  = "ami-062cf18d655c0b1e8"
  #   instance_type        = "t3.micro"
  #   volume               = 10
  #   is_public            = false
  #   subnet_name          = "private1"
  #   security_group_names = ["db-unique"]
  # }
]

# RDS 
# 사용하지 않으면: is_rds = false
is_rds = false

rds_sg = [ 
  { 
    name    = "rds-db"
    ingress = [
      {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
]

rds_config = {
  rds_name              = "my-rds-instance"
  allocated_storage     = 20
  max_allocated_storage = 100
  db_name               = "mydatabase"
  engine                = "mysql"
  engine_version        = "8.0.32"
  instance_class        = "db.t4g.micro"
  username              = "admin"
  password              = "password123"
  security_group_names  = ["rds-db"]
  skip_final_snapshot   = true
}


# ECR 
# 사용하지 않으면: ecr_repositories = []
ecr_repositories = [
  # {
  #   name                   = "repo1"
  #   image_tag_mutability   = "MUTABLE"
  #   image_scanning_enabled = false
  #   lifecycle_policy       = false 
  #   tags = {
  #     type = "CI/CD"
  #   }
  # },
  # {
  #   name                   = "repo2"
  #   image_tag_mutability   = "MUTABLE"
  #   image_scanning_enabled = false
  #   lifecycle_policy       = true
  #   tags = {
  #     type = "CI/CD"
  #   }
  # }
]

# S3
# 사용하지 않으면: s3_buckets = {} 
s3_buckets = {
  "bucket1" = {
    bucket_name             = "terraform-farmmate-my-example-bucket-1"
    enable_website_hosting  = true
    enable_cors             = true
    enable_public_access    = true
    block_public_acls       = true
    ignore_public_acls      = true
    block_public_policy     = true
    restrict_public_buckets = true
    environment             = "production"
  },
  # "bucket2" = {
  #   bucket_name             = "terraform-farmmate-my-example-bucket-2"
  #   enable_website_hosting  = false
  #   enable_cors             = false
  #   enable_public_access    = false
  #   block_public_acls       = true
  #   ignore_public_acls      = true
  #   block_public_policy     = true
  #   restrict_public_buckets = true
  #   environment             = "development"
  # }
}

# dynamodb
dynamodb_tables = [
  {
    table_name = "UserTable"
    partition_key = {
      name = "UserID"
      type = "S"
    }
    sort_key = {
      name = "Timestamp"
      type = "N"
    }
    tags = {
      Environment = "production"
      Project     = "UserProject"
    }
  },
  {
    table_name = "ProductTable"
    partition_key = {
      name = "ProductID"
      type = "S"
    }
    tags = {
      Environment = "development"
      Project     = "ProductProject"
    }
  }
]