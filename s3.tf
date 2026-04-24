locals {
  github_actions_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github-oidc"
}

module "deployment" {
  source  = "app.terraform.io/denilson-lehner-portfolio/bucket/aws"
  version = "0.0.2"

  name              = "${data.aws_region.current.name}-${var.dns_aliases[0]}"
  acl               = "public-read"
  enable_versioning = false
  policy            = data.aws_iam_policy_document.deployment.json

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "deployment" {
  statement {
    sid = "AllowWriter"
    actions = [
      "s3:Put*",
      "s3:Delete*",
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "${module.deployment.arn}",
      "${module.deployment.arn}/*",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "${local.github_actions_role_arn}"
      ]
    }
  }
}

module "edge_deployment" {
  source  = "app.terraform.io/denilson-lehner-portfolio/bucket/aws"
  version = "0.0.2"

  name              = "${data.aws_region.current.name}-${var.application_name}-edge-${var.environment}"
  acl               = "private"
  enable_versioning = false
  policy            = data.aws_iam_policy_document.edge_deployment.json

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "edge_deployment" {
  statement {
    sid = "AllowWriter"
    actions = [
      "s3:Put*",
      "s3:Delete*",
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      "${module.edge_deployment.arn}",
      "${module.edge_deployment.arn}/*",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "${local.github_actions_role_arn}"
      ]
    }
  }
}
