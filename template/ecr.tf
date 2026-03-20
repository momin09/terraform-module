resource "aws_ecr_repository" "ecr-repository" {
  name = var.name
  region = var.region

  tags = local.tags
}
