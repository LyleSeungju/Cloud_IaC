# AWS Region
region = "ap-northeast-2"

# VPC
vpc_cidr = "192.168.0.0/22"
vpc_name = "my-vpc"

# IGW
igw_name = "my-igw"

# Subnet
public_subnet = {
  cidr = "192.168.0.0/24"
  az   = "ap-northeast-2a"
  name = "my-public-subnet"
}

private_subnets = [
  {
    cidr = "192.168.1.0/24"
    az   = "ap-northeast-2a"
    name = "my-private-subnet-1"
  },
  {
    cidr = "192.168.2.0/24"
    az   = "ap-northeast-2c"
    name = "my-private-subnet-2"
  }
]

# NAT
nat_name = "my-nat"

# Route Table
public_route_table_name  = "my-public-rt"
private_route_table_name = "my-private-rt"

# Security Groups
sg_name = "my-sg"
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
instance_type          = "t2.micro"
key_name               = "aws-ktb-key"

instance_public_count  = 1
instance_private_count = 2


# RDS
allocated_storage    = 10
db_name              = "mydb"
engine               = "mysql"
engine_version       = "8.0.35"
instance_class       = "db.t4g.micro"
username             = "root"
password             = "rootmaster"
parameter_group_name = "default.mysql8.0"
skip_final_snapshot  = true
max_allocated_storage = 100


# S3
