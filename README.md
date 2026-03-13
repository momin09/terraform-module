# VPC Service

AWS VPC 네트워크 인프라를 Terraform으로 관리하는 서비스 브랜치입니다.

---

## 파일 구조

```
service/vpc
├── main.tf                    # VPC 및 관련 네트워크 리소스 정의
├── variables.tf               # 입력 변수 선언
├── outputs.tf                 # 출력값 정의
├── versions.tf                # Provider 및 Terraform 버전 고정
├── terraform.tfvars.example   # 변수 예시 파일
├── .gitignore                 # 민감 파일 제외
└── README.md                  # 이 문서
```

---

## 아키텍처

```
VPC (10.0.0.0/16)
├── 퍼블릭 서브넷 (AZ-a: 10.0.1.0/24, AZ-c: 10.0.2.0/24)
│   └── NAT Gateway (각 AZ별 또는 단일)
├── 프라이빗 서브넷 (AZ-a: 10.0.11.0/24, AZ-c: 10.0.12.0/24)
└── 인터넷 게이트웨이
```

---

## 생성되는 리소스

| 리소스 | 설명 |
|--------|------|
| `aws_vpc` | VPC 생성 |
| `aws_internet_gateway` | 인터넷 게이트웨이 |
| `aws_subnet` (public) | 퍼블릭 서브넷 (AZ별) |
| `aws_subnet` (private) | 프라이빗 서브넷 (AZ별) |
| `aws_eip` | NAT Gateway용 Elastic IP |
| `aws_nat_gateway` | NAT Gateway (선택) |
| `aws_route_table` | 퍼블릭/프라이빗 라우팅 테이블 |
| `aws_route_table_association` | 서브넷-라우팅 테이블 연결 |

---

## 사용 방법

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

---

## 변수 설명

| 변수 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `aws_region` | string | `ap-northeast-2` | AWS 리전 |
| `project_name` | string | - | 프로젝트 이름 (필수) |
| `environment` | string | `dev` | 환경 (dev/staging/prod) |
| `vpc_cidr` | string | `10.0.0.0/16` | VPC CIDR |
| `public_subnet_cidrs` | list | `[10.0.1.0/24, ...]` | 퍼블릭 서브넷 CIDR |
| `private_subnet_cidrs` | list | `[10.0.11.0/24, ...]` | 프라이빗 서브넷 CIDR |
| `availability_zones` | list | `[ap-northeast-2a, ...]` | 사용할 AZ |
| `enable_nat_gateway` | bool | `true` | NAT Gateway 활성화 |
| `single_nat_gateway` | bool | `false` | 단일 NAT (비용 절감) |
| `enable_dns_hostnames` | bool | `true` | DNS 호스트명 활성화 |
| `enable_dns_support` | bool | `true` | DNS 지원 활성화 |

### NAT Gateway 옵션

| 설정 | 비용 | 가용성 | 권장 환경 |
|------|------|--------|-----------|
| `single_nat_gateway = true` | 낮음 | 단일 AZ 의존 | dev/staging |
| `single_nat_gateway = false` | 높음 | AZ별 독립 NAT | prod |

---

## 피처 브랜치

| 피처 | 브랜치명 | 설명 |
|------|----------|------|
| NAT Gateway | `feature/vpc-nat-gateway` | NAT Gateway 고급 설정 |
| VPN | `feature/vpc-vpn` | Site-to-Site VPN 구성 |
| VPC Peering | `feature/vpc-peering` | VPC 간 피어링 |
| 보안 그룹 | `feature/vpc-security-groups` | 공통 보안 그룹 |

---

## 주의사항

- NAT Gateway는 시간당 비용 발생 (~$0.045/h)
- dev 환경은 `single_nat_gateway = true` 권장
- `terraform.tfvars`는 git에 커밋하지 마세요 (`.gitignore` 포함됨)
