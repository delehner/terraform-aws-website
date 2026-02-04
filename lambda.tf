data "archive_file" "dummy_request" {
  type        = "zip"
  output_path = "./tmp/dummy.zip"
  source {
    content  = <<EOF
exports.handler = async (event, context) => {
  return {
    statusCode: 200,
    body: "Just a dummy!"
  };
};
EOF
    filename = "viewer_request.js"
  }
}

data "archive_file" "dummy_response" {
  type        = "zip"
  output_path = "./tmp/dummy.zip"
  source {
    content  = <<EOF
exports.handler = async (event, context) => {
  return {
    statusCode: 200,
    body: "Just a dummy!"
  };
};
EOF
    filename = "viewer_response.js"
  }
}

resource "aws_lambda_function" "viewer_request" {
  function_name                  = "${var.application_name}-edge-request-${var.environment}"
  handler                        = "viewer_request.handler"
  runtime                        = var.application_runtime
  role                           = aws_iam_role.application.arn
  reserved_concurrent_executions = var.concurrent_executions
  timeout                        = var.lambda_timeout
  publish                        = true
  filename                       = data.archive_file.dummy_request.output_path
  source_code_hash               = data.archive_file.dummy_request.output_base64sha256

  lifecycle {
    ignore_changes = [
      tags,
      filename,
      source_code_hash
    ]
  }
}

resource "aws_lambda_function" "viewer_response" {
  function_name                  = "${var.application_name}-edge-response-${var.environment}"
  handler                        = "viewer_response.handler"
  runtime                        = var.application_runtime
  role                           = aws_iam_role.application.arn
  reserved_concurrent_executions = var.concurrent_executions
  timeout                        = var.lambda_timeout
  publish                        = true
  filename                       = data.archive_file.dummy_response.output_path
  source_code_hash               = data.archive_file.dummy_response.output_base64sha256

  lifecycle {
    ignore_changes = [
      tags,
      filename,
      source_code_hash
    ]
  }
}
