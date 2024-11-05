variable "rds_name" {
  description = "RDS 인스턴스 이름"
  type        = string
}

variable "allocated_storage" {
  description = "초기 할당된 스토리지 크기 (GB)"
  type        = number
}

variable "max_allocated_storage" {
  description = "자동 확장 스토리지의 최대 크기 (GB)"
  type        = number
}

variable "db_name" {
  description = "데이터베이스 이름"
  type        = string
}

variable "engine" {
  description = "RDS 엔진 (예: mysql)"
  type        = string
}

variable "engine_version" {
  description = "RDS 엔진 버전"
  type        = string
}

variable "instance_class" {
  description = "RDS 인스턴스 유형 (예: db.t3.micro)"
  type        = string
}

variable "username" {
  description = "데이터베이스 관리자 사용자 이름"
  type        = string
}

variable "password" {
  description = "데이터베이스 관리자 비밀번호"
  type        = string
  sensitive   = true
}

variable "skip_final_snapshot" {
  description = "인스턴스 삭제 시 최종 스냅샷 생성을 건너뜀 (true/false)"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "RDS가 위치할 서브넷의 ID 목록"
  type        = list(string)
}

variable "security_group_ids" {
  description = "RDS 인스턴스에 적용될 보안 그룹 ID"
  type        = list(string)
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}