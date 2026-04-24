resource "aws_iam_role" "application" {
  name               = "${data.aws_region.current.name}-${var.application_name}-edge-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid = "AssumeRole"

    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "edgelambda.amazonaws.com",
        "lambda.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "application" {
  role       = aws_iam_role.application.id
  policy_arn = aws_iam_policy.application.arn
}

resource "aws_iam_policy" "application" {
  name   = "${data.aws_region.current.name}-${var.application_name}-edge-${var.environment}-policy"
  policy = data.aws_iam_policy_document.application.json
}

data "aws_iam_policy_document" "application" {
  statement {
    sid = "CloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}
