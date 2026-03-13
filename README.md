# ECR Service

AWS ECR(Elastic Container Registry) 컨테이너 이미지 레지스트리를 Terraform으로 관리하는 서비스 브랜치입니다.

---

## 파일 구조

```
service/ecr
├── main.tf                    # ECR 리포지토리 및 관련 리소스 정의
├── variables.tf               # 입력 변수 선언
├── outputs.tf                 # 출력값 정의
├── versions.tf                # Provider 및 Terraform 버전 고정
├── terraform.tfvars.example   # 변수 예시 파일
├── .gitignore                 # 민감 파일 제외
└── README.md                  # 이 문서
```

---

## 생성되는 리소스

| 리소스 | 설명 |
|--------|------|
| `aws_ecr_repository` | ECR 이미지 리포지토리 |
| `aws_ecr_lifecycle_policy` | 오래된 이미지 자동 삭제 정책 |
| `aws_ecr_repository_policy` | 리포지토리 접근 제어 정책 |

---

## 사용 방법

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

### Docker 이미지 푸시

```bash
aws ecr get-login-password --region ap-northeast-2 | \
  docker login --username AWS --password-stdin <repository_url>

docker tag myapp:latest <repository_url>:latest
docker push <repository_url>:latest
```

---

## 변수 설명

| 변수 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `aws_region` | string | `ap-northeast-2` | AWS 리전 |
| `project_name` | string | - | 프로젝트 이름 (필수) |
| `environment` | string | `dev` | 환경 (dev/staging/prod) |
| `repository_name` | string | - | 리포지토리 이름 suffix (필수) |
| `image_tag_mutability` | string | `IMMUTABLE` | 이미지 태그 변경 가능 여부 |
| `scan_on_push` | bool | `true` | 푸시 시 자동 보안 스캔 |
| `enable_lifecycle_policy` | bool | `true` | 라이프사이클 정책 활성화 |
| `max_image_count` | number | `30` | 보관할 최대 이미지 수 |

> **리포지토리 이름**: `{project_name}-{environment}-{repository_name}` (예: `myproject-prod-api`)

---

## 피처 브랜치

| 피처 | 브랜치명 | 설명 |
|------|----------|------|
| 라이프사이클 정책 | `feature/ecr-lifecycle-policy` | 고급 라이프사이클 규칙 |
| 크로스 계정 접근 | `feature/ecr-cross-account` | 타 AWS 계정 접근 허용 |
| 리전 복제 | `feature/ecr-replication` | 다른 리전으로 이미지 복제 |

---

## 주의사항

- `IMMUTABLE` 태그 설정 시 동일 태그로 이미지를 덮어쓸 수 없습니다
- `terraform.tfvars`는 git에 커밋하지 마세요 (`.gitignore` 포함됨)
