# RDS
variable "rds_count" {
  description = "RDS 생성 여부"
  type        = number
  default     = 0
}

variable "rds_name" {
  description = "RDS 이름"
  type        = string
  default     = "terraformrds"
}

variable "allocated_storage" {
  description = "RDS의 초기 스토리지 크기"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "RDS 데이터베이스 이름"
  type        = string
}

variable "engine" {
  description = "RDS 엔진 종류"
  type        = string
}

variable "engine_version" {
  description = "RDS 엔진 버전"
  type        = string
}

variable "instance_class" {
  description = "RDS 인스턴스 클래스"
  type        = string
  default     = "db.t4g.micro" # 프리티어
}

variable "username" {
  description = "RDS 관리자 사용자 이름"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "RDS 관리자 비밀번호"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "parameter_group_name" {
  description = "RDS 파라미터 그룹 이름"
  type        = string
  default     = "terraformparameter"
}

variable "skip_final_snapshot" {
  description = "삭제 시 최종 스냅샷 생성 여부"
  type        = bool
  default     = true
}

variable "max_allocated_storage" {
  description = "RDS 자동 확장 최대 스토리지"
  type        = number
  default     = 22
}