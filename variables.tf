variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "project_name" {
  description = "프로젝트 이름 (태그에 사용)"
  type        = string
}

variable "environment" {
  description = "배포 환경 (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment는 dev, staging, prod 중 하나여야 합니다."
  }
}

variable "repository_name" {
  description = "ECR 리포지토리 이름 suffix"
  type        = string
}

variable "image_tag_mutability" {
  description = "이미지 태그 변경 가능 여부 (MUTABLE | IMMUTABLE)"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "MUTABLE 또는 IMMUTABLE 이어야 합니다."
  }
}

variable "scan_on_push" {
  description = "이미지 푸시 시 자동 보안 스캔"
  type        = bool
  default     = true
}

variable "enable_lifecycle_policy" {
  description = "라이프사이클 정책 활성화"
  type        = bool
  default     = true
}

variable "max_image_count" {
  description = "보관할 최대 이미지 수"
  type        = number
  default     = 30
}
