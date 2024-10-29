# AWS Region
provider "aws" {
  region = var.region
}

# VPC
module "vpc" {
  source   = "./modules/vpc"
  cidr_block = var.vpc_cidr
  name     = var.vpc_name
}

# IGW
module "internet_gateway" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.vpc_id
  name   = var.igw_name
}

# Subnet
module "subnet" {
  source          = "./modules/subnet"
  vpc_id          = module.vpc.vpc_id
  public_subnet   = var.public_subnet
  private_subnets = var.private_subnets
}

# NAT
module "nat_gateway" {
  source    = "./modules/nat_gateway"
  subnet_id = module.subnet.public_subnet_id
  name      = var.nat_name
}

# Route Table
module "route_table" {
  source                   = "./modules/route_table"
  vpc_id                   = module.vpc.vpc_id
  gateway_id               = module.internet_gateway.igw_id
  public_subnet_id         = module.subnet.public_subnet_id
  nat_gateway_id           = module.nat_gateway.nat_gateway_id
  private_subnet_ids       = module.subnet.private_subnet_ids
  public_route_table_name  = var.public_route_table_name
  private_route_table_name = var.private_route_table_name
}

# Security Groups
module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  name   = var.sg_name
  ingress = var.ingress
  egress  = var.egress
}

# EC2 Instance
module "instance" {
  source                 = "./modules/instance"
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  public_subnet_id       = module.subnet.public_subnet_id
  private_subnet_ids     = module.subnet.private_subnet_ids
  security_group_id      = module.security_group.security_group_id
  instance_public_count  = var.instance_public_count
  instance_private_count = var.instance_private_count
}

# RDS
module "rds" {
  source               = "./modules/rds"
  count                = var.rds_count
  name                 = var.rds_name
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = var.skip_final_snapshot
  max_allocated_storage = var.max_allocated_storage
  security_group_id    = module.security_group.security_group_id
  subnet_ids           = module.subnet.private_subnet_ids
}


# S3
