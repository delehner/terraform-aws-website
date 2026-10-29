locals {
  github_actions_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github-oidc"
}

resource "aws_s3_bucket" "deployment" {
  bucket = "${data.aws_region.current.name}-${var.dns_aliases[0]}"

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_s3_bucket_policy" "deployment" {
  bucket = aws_s3_bucket.deployment.id
  policy = data.aws_iam_policy_document.deployment.json

  # The policy grants public read (Principal "*"). New buckets are created with
  # Block Public Access enabled, so the block must be lifted first or
  # PutBucketPolicy fails with AccessDenied.
  depends_on = [aws_s3_bucket_public_access_block.deployment]
}

resource "aws_s3_bucket_ownership_controls" "deployment" {
  bucket = aws_s3_bucket.deployment.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "deployment" {
  bucket = aws_s3_bucket.deployment.id
  acl    = "public-read"

  # ACLs require ownership controls other than BucketOwnerEnforced, and a public
  # ACL requires Block Public Access to be lifted first.
  depends_on = [
    aws_s3_bucket_ownership_controls.deployment,
    aws_s3_bucket_public_access_block.deployment,
  ]
}

resource "aws_s3_bucket_versioning" "deployment" {
  bucket = aws_s3_bucket.deployment.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "deployment" {
  bucket = aws_s3_bucket.deployment.id

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
      aws_s3_bucket.deployment.arn,
      "${aws_s3_bucket.deployment.arn}/*",
    ]

    principals {
      type = "AWS"
      identifiers = [
        local.github_actions_role_arn,
      ]
    }
  }

  statement {
    sid     = "AllowPublicRead"
    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.deployment.arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket" "edge_deployment" {
  bucket = "${data.aws_region.current.name}-${var.application_name}-edge-${var.environment}"

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_s3_bucket_policy" "edge_deployment" {
  bucket = aws_s3_bucket.edge_deployment.id
  policy = data.aws_iam_policy_document.edge_deployment.json
}

resource "aws_s3_bucket_ownership_controls" "edge_deployment" {
  bucket = aws_s3_bucket.edge_deployment.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "edge_deployment" {
  bucket = aws_s3_bucket.edge_deployment.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.edge_deployment]
}

resource "aws_s3_bucket_versioning" "edge_deployment" {
  bucket = aws_s3_bucket.edge_deployment.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "edge_deployment" {
  bucket = aws_s3_bucket.edge_deployment.id

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
      aws_s3_bucket.edge_deployment.arn,
      "${aws_s3_bucket.edge_deployment.arn}/*",
    ]

    principals {
      type = "AWS"
      identifiers = [
        local.github_actions_role_arn,
      ]
    }
  }
}
