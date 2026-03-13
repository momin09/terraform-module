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

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "퍼블릭 서브넷 CIDR 목록"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "프라이빗 서브넷 CIDR 목록"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  description = "사용할 가용 영역 목록"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "enable_nat_gateway" {
  description = "NAT Gateway 활성화 여부"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "단일 NAT Gateway 사용 여부 (true: 비용 절감, false: 고가용성)"
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "VPC DNS 호스트명 활성화"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "VPC DNS 지원 활성화"
  type        = bool
  default     = true
}
