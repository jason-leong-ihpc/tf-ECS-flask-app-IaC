locals {
  name_prefix = "ce8-coaching18"
}

resource "aws_s3_bucket" "static_bucket" {
  bucket        = "${local.name_prefix}-s3"
  force_destroy = true
}

resource "aws_iam_role" "s3_app_exec" {
  name = "${local.name_prefix}-s3-app-executionrole"

  assume_role_policy = data.aws_iam_policy_document.s3_static_bucket_policy.json
}


# resource "aws_s3_bucket_public_access_block" "enable_public_access" {
#   bucket = aws_s3_bucket.static_bucket.id

#   block_public_acls       = true
#   block_public_policy     = false
#   ignore_public_acls      = true
#   restrict_public_buckets = false
# }

