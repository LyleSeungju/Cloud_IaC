variable "instances" {
  description = "EC2 인스턴스 설정 목록"
  type = list(object({
    name                 = string
    instance_type        = string
    ami                  = string
    is_public            = bool               # 퍼블릭 서브넷 여부
    subnet_name          = string            # 서브넷 이름
    security_group_names = list(string)     # 보안 그룹 이름 리스트
  }))
}
module "instances" {
  source  = "./modules/instance"
  for_each = { for instance in var.instances : instance.name => instance }

  name               = each.value.name
  instance_type      = each.value.instance_type
  ami                = each.value.ami
  subnet_id          = each.value.is_public ? module.public_subnet_group.subnet_ids[each.value.subnet_name] : module.private_subnet_group.subnet_ids[each.value.subnet_name]
  security_group_ids = [
    for sg_name in each.value.security_group_names : module.security_groups[sg_name].security_group_id
  ]

  tags = {
    Environment = "dev"
    Name        = "${module.vpc.name}-instance-${each.value.name}"
  }
}
