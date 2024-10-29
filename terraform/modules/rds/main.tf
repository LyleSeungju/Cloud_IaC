resource "aws_db_subnet_group" "default" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids
  description = "RDS Subnet Group for ${var.db_name}"
}

resource "aws_db_instance" "default" {
  count                  = var.count                            # RDS 생성 여부 / 생성하지 않으면 0
  allocated_storage      = var.allocated_storage                # 초기 할당된 스토리지 크기
  db_name                = var.db_name                          # RDS 이름
  engine                 = var.engine                           # RDS 엔진
  engine_version         = var.engine_version                   # RDS 엔진 버젼
  instance_class         = var.instance_class                   # 인스턴스 유형
  username               = var.username                         # 데이터베이스 관리자 이름
  password               = var.password                         # 데이터베이스 관리자 비밀번호
  parameter_group_name   = var.parameter_group_name             # 사용할 파라미터 그룹
  skip_final_snapshot    = var.skip_final_snapshot              # 인스턴스 삭세할 때 최종 스냅샷 생성을 건너뜀 (true면 생성되지 않음)
  max_allocated_storage  = var.max_allocated_storage            # 최대 자동 확장 스토리지 크기
  vpc_security_group_ids = [var.security_group_id]              # VPC에 소속된 보안그룹
  db_subnet_group_name   = aws_db_subnet_group.default.name     # RDS에 할당할 서브넷 그룹

  tags = {
    Name = var.name
  }
}