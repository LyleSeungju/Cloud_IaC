variable "count" {
  description = "RDS 생성 여부"
  type        = number
}

variable "name" {
  description = "RDS 이름"
  type        = string
}

variable "allocated_storage" {
  description = "RDS의 초기 스토리지 크기"
  type        = number
}

variable "db_name" {
  description = "RDS 데이터베이스 이름"
  type        = string
}

variable "engine" {
  description = "RDS 엔진 종류 (예: mysql)"
  type        = string
}

variable "engine_version" {
  description = "RDS 엔진 버전"
  type        = string
}

variable "instance_class" {
  description = "RDS 인스턴스 클래스"
  type        = string
}

variable "username" {
  description = "RDS 관리자 사용자 이름"
  type        = string
}

variable "password" {
  description = "RDS 관리자 비밀번호"
  type        = string
  sensitive   = true
}

variable "parameter_group_name" {
  description = "RDS 파라미터 그룹 이름"
  type        = string
}

variable "skip_final_snapshot" {
  description = "삭제 시 최종 스냅샷 생성 여부"
  type        = bool
  default     = true
}

variable "max_allocated_storage" {
  description = "RDS 자동 확장 최대 스토리지"
  type        = number
}

variable "security_group_id" {
  description = "RDS가 사용할 보안 그룹 ID"
  type        = string
}

variable "subnet_ids" {
  description = "RDS가 위치할 서브넷 ID 목록"
  type        = list(string)
}