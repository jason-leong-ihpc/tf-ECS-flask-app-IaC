locals {
  name_prefix = split("/", data.aws_caller_identity.current.arn)[1]
  # tags = {
  #   Purpose = "CE 8 - Coaching 17"
  # }
}


