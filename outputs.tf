output "cloudfront" {
  value       = aws_cloudfront_distribution.cdn
  description = "Application CloudFront."
}

output "artifacts_bucket" {
  value       = module.deployment
  description = "Artifacts bucket."
}
