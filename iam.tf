### CREATE POLICIES FROM POLICY DOCUMENTS ###

resource "aws_iam_policy" "s3_app_policy" {
  name   = "${local.name_prefix}-s3-app-policy"
  policy = data.aws_iam_policy_document.s3_data_bucket_policy.json
}

resource "aws_iam_policy" "sqs_app_policy" {
  name   = "${local.name_prefix}-sqs-app-policy"
  policy = data.aws_iam_policy_document.sqs_message_policy.json
}

### CREATE IAM ROLE AND ATTACH POLICY ###

resource "aws_iam_role" "ecs_role_s3_app" {
  name = "${local.name_prefix}-ecs-role-s3-app"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

resource "aws_iam_role" "ecs_role_sqs_app" {
  name = "${local.name_prefix}-ecs-role-sqs-app"

  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

### ATTACH THE S3 POLICY TO THE IAM ROLE ###

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ecs_role_s3_app.name
  policy_arn = aws_iam_policy.s3_app_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_sqs_policy" {
  role       = aws_iam_role.ecs_role_sqs_app.name
  policy_arn = aws_iam_policy.sqs_app_policy.arn
}