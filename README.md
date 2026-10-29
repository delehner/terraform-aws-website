# Terraform - Website Module

This Terraform module provides all the necessary resources to deploy a website application architecture on AWS: a public S3 deployment bucket, a private S3 bucket for Lambda@Edge artifacts, viewer-request and viewer-response Lambda@Edge functions (with placeholder code), a CloudFront distribution and Route 53 alias records.

Lambda@Edge functions must be created in `us-east-1`, so the AWS provider passed to this module must target that region.

## Usage

```hcl
module "website" {
  source  = "app.terraform.io/<org>/website/aws"
  version = "~> 1.0"

  application_name = "website-boilerplate"
  environment      = "development"
  dns_aliases      = ["website-boilerplate-development.example.com"]
  domain           = "example.com"

  # Optional — bind a WAFv2 Web ACL ARN to the CloudFront distribution.
  web_acl_id = null
}
```

The module expects a public Route 53 hosted zone and an issued ACM certificate for `domain`, and an IAM role named `github-oidc` in the account (it gets write access to the buckets).

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `application_name` | `string` | n/a | Application's name. |
| `environment` | `string` | n/a | Environment where the resource is running. |
| `dns_aliases` | `list(string)` | n/a | DNS aliases. The first one also names the deployment bucket. |
| `domain` | `string` | n/a | The domain for the hosted zone (and ACM certificate). |
| `comment` | `string` | `""` | Comment for the CloudFront resource. |
| `default_root_object` | `string` | `"index.html"` | Default root object for the website. |
| `min_ttl` | `number` | `0` | Min TTL. |
| `default_ttl` | `number` | `3600` | Default TTL. |
| `max_ttl` | `number` | `86400` | Max TTL. |
| `restriction_type` | `string` | `"none"` | Type of geo restriction. |
| `locations` | `list(string)` | `[]` | Restriction to locations. |
| `price_class` | `string` | `"PriceClass_100"` | CloudFront's price class. |
| `application_runtime` | `string` | `"nodejs22.x"` | Runtime of the viewer-request and viewer-response Lambda@Edge functions. |
| `lambda_timeout` | `number` | `5` | Lambda timeout. |
| `log_retention_in_days` | `number` | `7` | AWS CloudWatch log retention in days. |
| `concurrent_executions` | `number` | `-1` | Number of Lambda concurrent executions. |
| `web_acl_id` | `string` | `null` | Optional WAFv2 Web ACL ARN to bind to the CloudFront distribution. |

## Outputs

| Name | Description |
|------|-------------|
| `cloudfront` | Application CloudFront distribution. |
| `artifacts_bucket` | Deployment bucket (`name` is the bucket domain name, `arn` its ARN). |

See [CHANGELOG.md](CHANGELOG.md) for release notes.
