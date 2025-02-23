locals {
  name_prefix = "ce8-coaching18"
}

resource "aws_s3_bucket" "static_bucket" {
  bucket        = "${local.name_prefix}-s3"
  force_destroy = true
}