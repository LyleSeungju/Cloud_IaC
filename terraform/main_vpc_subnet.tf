# Subnet
variable "public_subnets" {
  description = "퍼블릭 서브넷 구성 정보"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}
module "public_subnet_group" {
  source                  = "./modules/subnets"
  name                    = "${module.vpc.name}-public-subnet"
  vpc_id                  = module.vpc.vpc_id
  map_public_ip_on_launch = true
  subnets                 = var.public_subnets
}


variable "private_subnets" {
  description = "프라이빗 서브넷 구성 정보"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}
module "private_subnet_group" {
  source                  = "./modules/subnets"
  name                    = "${module.vpc.name}-private-subnet"
  vpc_id                  = module.vpc.vpc_id
  map_public_ip_on_launch = false
  subnets                 = var.private_subnets
}
