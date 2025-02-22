resource "aws_ecr_repository" "ecr" {
  name         = "${local.name_prefix}-ecr"
  force_delete = true
}

