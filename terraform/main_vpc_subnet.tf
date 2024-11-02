# Subnet
variable "public_subnets" {
  description = "퍼블릭 서브넷 구성 정보. VPC 내에서 퍼블릭 서브넷을 생성하기 위해 필요한 설정을 정의합니다."
  type = map(object({
    cidr_block        = string  # 서브넷의 CIDR 블록. 서브넷에 할당할 IP 주소 범위입니다 (예: "192.168.1.0/24").
    availability_zone = string  # 서브넷이 위치할 가용 영역. AWS 리전 내에서 특정 가용 영역을 지정합니다 (예: "ap-northeast-2a").
  }))
}
module "public_subnet" {
  source                  = "./modules/subnets"
  for_each                = var.public_subnets
  name                    = "${module.vpc.name}-subnet-${each.key}"
  vpc_id                  = module.vpc.vpc_id
  map_public_ip_on_launch = true
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
}
# export: module.public_subnet["subnet_name"].subnet_id


variable "private_subnets" {
  description = "프라이빗 서브넷 구성 정보"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}
module "private_subnet" {
  source                  = "./modules/subnets"
  for_each                = var.private_subnets
  name                    = "${module.vpc.name}-subnet-${each.key}"
  vpc_id                  = module.vpc.vpc_id
  map_public_ip_on_launch = true
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
}
# export: module.private_subnet["subnet_name"].subnet_id