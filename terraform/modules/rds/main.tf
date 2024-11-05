# 서브넷 그룹 생성 (RDS가 사용할 서브넷을 그룹화)
resource "aws_db_subnet_group" "this" {
  name       = "${var.rds_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, { Name = "${var.rds_name}-subnet-group" })

  description = "Subnet group for RDS instance ${var.rds_name}"
}

# RDS 인스턴스 생성
resource "aws_db_instance" "this" {
  identifier             = var.rds_name                     # RDS 인스턴스 이름
  allocated_storage      = var.allocated_storage            # 초기 할당된 스토리지 크기
  max_allocated_storage  = var.max_allocated_storage        # 최대 자동 확장 스토리지 크기
  db_name                = var.db_name                      # 데이터베이스 이름
  engine                 = var.engine                       # RDS 엔진 (예: mysql)
  engine_version         = var.engine_version               # RDS 엔진 버전
  instance_class         = var.instance_class               # 인스턴스 유형 (예: db.t3.micro)
  username               = var.username                     # 데이터베이스 관리자 사용자 이름
  password               = var.password                     # 데이터베이스 관리자 비밀번호
  skip_final_snapshot    = var.skip_final_snapshot          # 인스턴스 삭제 시 최종 스냅샷 생성을 건너뜀
  vpc_security_group_ids = var.security_group_ids          # VPC 보안 그룹
  db_subnet_group_name   = aws_db_subnet_group.this.name    # 서브넷 그룹 이름

  tags = merge(var.tags, { Name = var.rds_name })
}
