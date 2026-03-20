# ─── 테스트에 주입할 변수 ───
mock_provider "aws" {}

variables {
  yaml_dir = "./tests"
}

# ─── 시나리오 1: YAML 파일이 정상적으로 파싱되는지 ───
run "yaml_decoder_parses_files" {
  command = plan

  assert {
    condition     = length(module.yaml_decoder.files) > 0
    error_message = "yaml_decoder가 YAML 파일을 하나도 읽지 못했습니다."
  }
}

# ─── 시나리오 2: ECR 모듈이 올바른 개수만큼 생성되는지 ───
run "ecr_module_count_matches_yaml" {
  command = plan

  assert {
    condition     = length(module.ecr) == length(module.yaml_decoder.files)
    error_message = "ECR 모듈 수가 YAML 파일 수와 일치하지 않습니다."
  }
}

# ─── 시나리오 3: ECR 모듈 키가 YAML 파일명과 일치하는지 ───
run "ecr_module_key_matches_filename" {
  command = apply

  assert {
    condition     = contains(keys(module.ecr), "test-app")
    error_message = "ECR 모듈에 'test-app' 키가 존재하지 않습니다."
  }
}