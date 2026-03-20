variable "name" {
  description = "ECR 레포지토리 이름"
  type        = string
}

variable "region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "createdate" {
  description = "리소스 생성일 (YYYYMMDD)"
  type        = string
}

variable "tags" {
  description = "추가 태그 (optional)"
  type        = map(string)
  default     = {}
}
