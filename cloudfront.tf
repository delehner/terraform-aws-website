resource "aws_cloudfront_distribution" "cdn" {
  origin {
    origin_id   = "${var.application_name}-${var.environment}"
    domain_name = "${data.aws_region.current.name}-${var.dns_aliases[0]}.s3.${data.aws_region.current.name}.amazonaws.com"
  }

  aliases = var.dns_aliases

  enabled             = true
  comment             = var.comment
  default_root_object = var.default_root_object

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.application_name}-${var.environment}"

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    compress               = true

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = aws_lambda_function.viewer_request.qualified_arn
      include_body = false
    }

    lambda_function_association {
      event_type   = "viewer-response"
      lambda_arn   = aws_lambda_function.viewer_response.qualified_arn
      include_body = false
    }
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations        = var.locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = data.aws_acm_certificate.issued.arn
    ssl_support_method             = "sni-only"
  }

  lifecycle {
    ignore_changes = [
      tags,
      viewer_certificate,
      default_cache_behavior,
      ordered_cache_behavior,
    ]
  }
}
