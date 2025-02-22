resource "aws_ecr_repository" "app1" {
  name         = "${local.name_prefix}-s3"
  force_delete = true
}

resource "aws_ecr_repository" "app2" {
  name         = "${local.name_prefix}-sqs"
  force_delete = true
}