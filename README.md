# Terraform - Website Module

This Terraform module provides all the necessary resources to deploy a website application architecture on AWS.

## Usage

Here's a code example of how you can use this module:

```hcl
module "website" {
  source  = "app.terraform.io/<organization>/website/aws"
  version = "0.0.1"

  application_name = "website-boilerplate"
  environment      = "development"
  dns_aliases      = ["website-boilerplate-development.example.com"]
  domain           = "example.com"

  # Optional — bind a WAFv2 Web ACL ARN to the CloudFront distribution.
  web_acl_id = null
}
```
