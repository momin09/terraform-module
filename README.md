# Terraform 활용 가이드

Terraform은 HashiCorp에서 만든 **Infrastructure as Code(IaC)** 도구로, 클라우드 인프라를 코드로 선언하고 자동으로 프로비저닝할 수 있습니다.

---

## 목차

1. [설치](#설치)
2. [기본 개념](#기본-개념)
3. [기본 사용법](#기본-사용법)
4. [주요 명령어](#주요-명령어)
5. [예제: AWS EC2 인스턴스 생성](#예제-aws-ec2-인스턴스-생성)
6. [모범 사례](#모범-사례)

---

## 설치

### macOS (Homebrew)
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Linux
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### 설치 확인
```bash
terraform version
```

---

## 기본 개념

| 개념 | 설명 |
|------|------|
| **Provider** | AWS, GCP, Azure 등 클라우드/서비스 연결 플러그인 |
| **Resource** | 생성할 인프라 구성 요소 (EC2, S3, VPC 등) |
| **State** | 현재 인프라 상태를 저장하는 파일 (`terraform.tfstate`) |
| **Module** | 재사용 가능한 Terraform 코드 묶음 |
| **Variable** | 설정값을 외부에서 주입할 수 있는 변수 |
| **Output** | 프로비저닝 후 출력할 값 |

---

## 기본 사용법

### 1. 프로젝트 구조
```
my-terraform/
├── main.tf          # 주요 리소스 정의
├── variables.tf     # 변수 선언
├── outputs.tf       # 출력값 정의
├── terraform.tfvars # 변수 실제 값 (git에 올리지 않음)
└── versions.tf      # provider 버전 고정
```

### 2. Provider 설정 (`versions.tf`)
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}
```

### 3. 변수 선언 (`variables.tf`)
```hcl
variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t3.micro"
}
```

---

## 주요 명령어

```bash
# 1. 초기화 (provider 다운로드)
terraform init

# 2. 문법 검사 및 포맷팅
terraform validate
terraform fmt

# 3. 변경 사항 미리보기
terraform plan

# 4. 인프라 적용
terraform apply

# 5. 인프라 삭제
terraform destroy

# 6. 현재 상태 확인
terraform show

# 7. 리소스 목록 확인
terraform state list

# 8. 특정 리소스만 적용
terraform apply -target=aws_instance.example
```

---

## 예제: AWS EC2 인스턴스 생성

### `main.tf`
```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c9c942bd7bf113a2"  # Amazon Linux 2023
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id

  tags = {
    Name        = "web-server"
    Environment = "production"
  }
}
```

### `outputs.tf`
```hcl
output "instance_id" {
  description = "EC2 인스턴스 ID"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "EC2 퍼블릭 IP"
  value       = aws_instance.web.public_ip
}
```

---

## 모범 사례

1. **State를 원격에 저장** - S3 + DynamoDB로 팀 협업 시 state 충돌 방지
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "my-terraform-state"
       key            = "prod/terraform.tfstate"
       region         = "ap-northeast-2"
       dynamodb_table = "terraform-lock"
     }
   }
   ```

2. **변수값 파일은 `.gitignore`에 추가**
   ```
   *.tfvars
   .terraform/
   terraform.tfstate*
   ```

3. **`terraform plan`을 항상 먼저 실행** - 예상치 못한 변경 방지

4. **모듈 활용** - 반복되는 코드를 모듈로 추상화하여 재사용

5. **태그 전략 수립** - 모든 리소스에 일관된 태그(환경, 팀, 비용센터 등) 적용

---

## 유용한 링크

- [Terraform 공식 문서](https://developer.hashicorp.com/terraform/docs)
- [Terraform Registry (Provider/Module)](https://registry.terraform.io/)
- [AWS Provider 문서](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
