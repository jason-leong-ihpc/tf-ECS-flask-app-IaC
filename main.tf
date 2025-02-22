# locals {
#   name_prefix = split("/", data.aws_caller_identity.current.arn)[1]
# }

resource "aws_s3_bucket" "static_bucket" {
  bucket        = var.s3_bucket_name
  force_destroy = true
}


resource "aws_s3_bucket_public_access_block" "enable_public_access" {
  bucket = aws_s3_bucket.static_bucket.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

