output "cloudfront" {
  value       = aws_cloudfront_distribution.cdn
  description = "Application CloudFront."
}

output "artifacts_bucket" {
  value = {
    name = aws_s3_bucket.deployment.bucket_domain_name
    arn  = aws_s3_bucket.deployment.arn
  }
  description = "Artifacts bucket."
}
