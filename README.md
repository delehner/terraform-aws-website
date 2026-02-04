# Terraform - Website Module

This Terraform module provides all the necessary resources to deploy a website application architecture on AWS.

## Usage

Here's a code example of how you can use this module:

```hcl
module "website" {
  source  = "app.terraform.io/<organization>/website/aws"
  version = "0.0.1"

  dns_alias = "website-boilerplate-development.example.com"
  domain    = "example.com"
}
```
