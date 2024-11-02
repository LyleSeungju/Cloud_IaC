# Security Groups
variable "sg" {
  description = "보안 그룹 설정 목록. 각 보안 그룹의 인바운드 및 아웃바운드 규칙을 정의합니다."
  type = list(object({
    name    = string          # 보안 그룹의 이름입니다.
    ingress = list(object({   # 인바운드 규칙 목록으로, 허용할 트래픽을 정의합니다.
      from_port   = number    # 시작 포트 번호입니다.
      to_port     = number    # 종료 포트 번호입니다.
      protocol    = string    # 프로토콜 (예: tcp, udp, -1 (모든 프로토콜))입니다.
      cidr_blocks = list(string) # 허용할 CIDR 블록 목록입니다 (예: ["0.0.0.0/0"]).
    }))
    egress = list(object({    # 아웃바운드 규칙 목록으로, 허용할 트래픽을 정의합니다.
      from_port   = number    # 시작 포트 번호입니다.
      to_port     = number    # 종료 포트 번호입니다.
      protocol    = string    # 프로토콜 (예: tcp, udp, -1 (모든 프로토콜))입니다.
      cidr_blocks = list(string) # 허용할 CIDR 블록 목록입니다 (예: ["0.0.0.0/0"]).
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
# export: module.security_groups["security_group_name"].security_group_id