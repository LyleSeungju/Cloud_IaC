variable "is_rds" {
  description = "RDS 인스턴스를 생성할지 여부"
  type        = bool
  default     = false
}

variable "rds_config" {
  description = "RDS 설정을 위한 변수. RDS 인스턴스 생성에 필요한 구성 정보를 포함합니다."
  type = object({
    rds_name              = string            # 생성할 RDS 인스턴스의 이름입니다.
    allocated_storage     = number            # 초기 할당된 스토리지 크기 (GB)입니다.
    max_allocated_storage = number            # 자동 확장 시 최대 스토리지 크기 (GB)입니다.
    db_name               = string            # 데이터베이스 이름입니다.
    engine                = string            # 사용할 RDS 엔진 (예: mysql)입니다.
    engine_version        = string            # 사용할 RDS 엔진의 버전입니다.
    instance_class        = string            # RDS 인스턴스 유형 (예: db.t3.micro)입니다.
    username              = string            # 데이터베이스 관리자 사용자 이름입니다.
    password              = string            # 데이터베이스 관리자 비밀번호입니다. (이거 넣을때 반드시 우회해서 넣을 것 - 넣고 깃푸시 xxxx)
    security_group_names  = list(string)      # RDS 인스턴스에 연결할 보안 그룹의 이름 리스트입니다.
    skip_final_snapshot   = bool              # 인스턴스 삭제 시 최종 스냅샷 생성을 건너뛸지 여부 (true/false)입니다.
  })
  default = {  # 기본값으로 빈 객체를 설정하여 필요시 RDS 인스턴스 생성을 스킵할 수 있습니다.
    rds_name              = ""
    allocated_storage     = 0
    max_allocated_storage = 0
    db_name               = ""
    engine                = ""
    engine_version        = ""
    instance_class        = ""
    username              = ""
    password              = ""
    security_group_names  = []
    skip_final_snapshot   = true
  }  
}

# RDS 보안 그룹 모듈
variable "rds_sg" {
  description = "RDS 보안 그룹 설정 목록"
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
  default = [
    { 
      name    = "rds-db"
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
}

module "rds_security_groups" {
  source   = "./modules/security_group"
  for_each = { for sg in var.rds_sg : sg.name => sg }

  name          = each.value.name
  vpc_id        = module.vpc.vpc_id
  ingress_rules = each.value.ingress
  egress_rules  = each.value.egress

  tags = {
    Name = "${module.vpc.name}-sg-${each.value.name}"
  }
}

# rds-sg로 정의한 보안 그룹 이름을 자동으로 rds 정보로 입력
locals { 
  rds_security_group_names = [for sg in var.rds_sg : sg.name]
}

module "rds" {
  source                = "./modules/rds"                                               # RDS 모듈 경로
  count                 = var.is_rds && var.rds_config.rds_name != "" ? 1 : 0           # RDS 인스턴스 생성 여부 
  rds_name              = var.rds_config.rds_name                                       # RDS 인스턴스 이름 
  allocated_storage     = var.rds_config.allocated_storage                              # 초기 할당된 스토리지 크기 (GB)
  max_allocated_storage = var.rds_config.max_allocated_storage                          # 자동 확장 스토리지의 최대 크기 (GB)
  db_name               = var.rds_config.db_name                                        # 데이터베이스 이름
  engine                = var.rds_config.engine                                         # RDS 엔진 (예: mysql)
  engine_version        = var.rds_config.engine_version                                 # RDS 엔진 버전
  instance_class        = var.rds_config.instance_class                                 # RDS 인스턴스 유형
  username              = var.rds_config.username                                       # 데이터베이스 관리자 사용자 이름
  password              = var.rds_config.password                                       # 데이터베이스 관리자 비밀번호
  skip_final_snapshot   = var.rds_config.skip_final_snapshot                            # 인스턴스 삭제 시 최종 스냅샷 건너뛰기 여부
  subnet_ids            = [for key, subnet in module.private_subnet : subnet.subnet_id] # RDS가 위치할 서브넷 ID 목록

  # RDS 인스턴스에 적용될 보안 그룹 ID 목록을 설정
  security_group_ids = [
    for sg_name in local.rds_security_group_names : module.rds_security_groups[sg_name].security_group_id
  ]

  tags = {
    Environment = "production"
    Project     = "MyProject"
  }
}