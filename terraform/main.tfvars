# 지역 설정
region = "ap-northeast-2"

vpc_config = {
    name       = "farmmate"
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
        availability_zone = "ap-northeast-2a"
    }
}


# NAT gateway
nat = {
    enabled            = true
    public_subnet_name = "public1"
}

# Security Groups
sg = [
  { 
    name    = "web"
    ingress = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
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
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  },
  { 
    name    = "db"
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

# EC2
instances = [
  {
    name                 = "web-service"
    instance_type        = "t3.micro"
    ami                  = "ami-062cf18d655c0b1e8"
    is_public            = true 
    subnet_name          = "public1"
    security_group_names = ["web", "db"]
  },
  {
    name                 = "db-service"
    instance_type        = "t3.micro"
    ami                  = "ami-062cf18d655c0b1e8"
    is_public            = false
    subnet_name          = "private1"
    security_group_names = ["db"]
  }
]
