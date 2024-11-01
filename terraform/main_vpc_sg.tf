# Security Groups
variable "sg" {
  description = "보안 그룹 설정 목록"
  type = list(object({
    name    = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}
module "security_groups" {
  source   = "./modules/security_group"
  for_each = { for sg in var.sg : sg.name => sg }

  name          = each.value.name
  vpc_id        = module.vpc.vpc_id
  ingress_rules = each.value.ingress
  egress_rules  = each.value.egress

  tags = {
    Name = "${module.vpc.name}-sg-${each.value.name}"
  }
}