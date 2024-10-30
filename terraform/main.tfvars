# AWS Region
region = "ap-northeast-2"

# VPC
vpc_cidr = "192.168.0.0/16"
vpc_name = "test-vpc"

# IGW
igw_name = "test-igw"

# Subnet
public_subnet = {
  cidr = "192.168.0.0/24"
  az   = "ap-northeast-2a"
  name = "test-public-subnet"
}

private_subnets = [
  {
    cidr = "192.168.1.0/24"
    az   = "ap-northeast-2a"
    name = "test-private-subnet-1"
  },
  {
    cidr = "192.168.2.0/24"
    az   = "ap-northeast-2c"
    name = "test-private-subnet-2"
  }
]

# NAT
nat_name = "test-nat"

# Route Table
public_route_table_name  = "test-public-rt"
private_route_table_name = "test-private-rt"

# Security Groups
sg_name = "test-sg"
ingress = {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
egress = {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# EC2 Instance
ami                    = "ami-062cf18d655c0b1e8"
instance_type          = "t3.nano"
key_name               = "kakao-lyle"

instance_public_count  = 1
instance_private_count = 1


# RDS
allocated_storage    = 10
db_name              = "lyletestterraform"
engine               = "mysql"
engine_version       = "8.0.35"
instance_class       = "db.t4g.micro"
username             = "root"
password             = "rootmaster"


# S3
  