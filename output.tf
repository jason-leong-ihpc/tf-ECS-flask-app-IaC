# Output the S3 bucket name
output "s3_bucket_name" {
  value       = aws_s3_bucket.static_bucket.bucket
  description = "S3 bucket name"
}