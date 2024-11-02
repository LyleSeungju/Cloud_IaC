variable "instances" {
  description = "EC2 인스턴스 설정 목록"
  type = list(object({
    name                 = string           # EC2 인스턴스의 이름을 지정합니다.
    instance_type        = string           # EC2 인스턴스 유형을 지정합니다 (예: "t3.micro"). : 프리티어는 t2.micro
    ami                  = string           # 인스턴스에 사용할 AMI ID를 지정합니다.  : Amazon Linux 2023는 ami-02c329a4b4aba6a48
    volume               = number           # 인스턴스에 연결할 볼륨 크기를 GB 단위로 지정합니다. : Default는 8GB
    is_public            = bool             # 퍼블릭 서브넷에 배치할지 여부를 지정합니다 (true/false). : 퍼블릭 인스턴스일땐 true / 프라이빗 인스턴스일땐 false
    subnet_name          = string           # 인스턴스를 배치할 서브넷의 이름을 지정합니다. : 퍼블릭 인스턴스 - 퍼블릭 서브넷 형식 꼭 맞출것!!
    security_group_names = list(string)     # 인스턴스에 연결할 보안 그룹의 이름 목록을 지정합니다. : 배열 형태로 보안그룹 이름 지정
  }))
}
module "ec2_instance" {
  source  = "./modules/ec2_instance"
  for_each = { for instance in var.instances : instance.name => instance }

  name               = each.value.name
  instance_type      = each.value.instance_type
  ami                = each.value.ami
  volume             = each.value.volume
  subnet_id          = each.value.is_public ? module.public_subnet[each.value.subnet_name].subnet_id : module.private_subnet[each.value.subnet_name].subnet_id
  security_group_ids = [
    for sg_name in each.value.security_group_names : module.security_groups[sg_name].security_group_id
  ]

  tags = {
    Environment = "dev"
    Name        = "${module.vpc.name}-instance-${each.value.name}"
  }
}
