locals {
  name_prefix = "ce8-coaching18"
}

resource "aws_s3_bucket" "static_bucket" {
  bucket        = "${local.name_prefix}-s3"
  force_destroy = true
}

resource "aws_iam_policy" "s3_app_policy" {
  name   = "${local.name_prefix}-s3-app-policy"
  policy = data.aws_iam_policy_document.s3_data_bucket_policy.json
}

### CREATE IAM ROLE AND ATTACH POLICY ###

resource "aws_iam_role" "ecs_role" {
  name = "${local.name_prefix}-ecs-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

### ATTACH THE S3 POLICY TO THE IAM ROLE ###

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.s3_app_policy.arn
}