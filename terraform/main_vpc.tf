# Region
variable "region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

provider "aws" {
  region = var.region
}

# VPC
variable "vpc_config" {
  description = "VPC 설정"
  type = object({
    name       = string
    cidr_block = string
  })
  default = {
    name       = "terraform"
    cidr_block = "192.168.0.0/16"
  }
}

module "vpc" {
  source     = "./modules/vpc"
  name       = var.vpc_config.name
  cidr_block = var.vpc_config.cidr_block

  tags = {
    Name = "${var.vpc_config.name}-vpc"
  }
}
# export: module.vpc.vpc_id


# NAT Gateway
variable "nat" {
  description = "NAT 게이트웨이 정보"
  type = object({
    enabled            = bool
    public_subnet_name = string 
  })
  default = {
    enabled            = true
    public_subnet_name = "public1"
  }
}
module "nat_gateway" {
  source    = "./modules/nat_gateway"
  name      = "${module.vpc.name}-nat"
  enabled   = var.nat.enabled
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.public_subnet["${var.nat.public_subnet_name}"].subnet_id
}
# export: module.nat_gateway.nat_id



# Route Table
module "public_route_table" {
  source  = "./modules/route_table"
  name    = "${module.vpc.name}-rtb-public"
  vpc_id  = module.vpc.vpc_id
  subnets = [for key, subnet in module.public_subnet : subnet.subnet_id]

  ipv4_routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.vpc.internet_gateway_id
    }
  ]
}
# export: module.route_table.rtb_id

module "private_route_table" {
  source  = "./modules/route_table"
  name    = "${module.vpc.name}-rtb-private"
  vpc_id  = module.vpc.vpc_id
  subnets = [for key, subnet in module.private_subnet : subnet.subnet_id]

  ipv4_routes = [
    {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = module.nat_gateway.nat_id
    }
  ]
}
# export: module.route_table.rtb_id

