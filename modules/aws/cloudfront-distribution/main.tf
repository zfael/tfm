# CloudFront Distribution Module

locals {
  # CachingOptimized managed policy
  caching_optimized_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"

  cache_policy_id = coalesce(
    var.cache_policy_id,
    var.custom_cache_policy != null ? aws_cloudfront_cache_policy.this[0].id : null,
    local.caching_optimized_policy_id
  )
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = var.enabled
  default_root_object = var.default_root_object
  price_class         = var.price_class
  aliases             = var.aliases

  origin {
    domain_name              = var.origin_domain_name
    origin_id                = var.origin_id
    origin_path              = var.origin_path != "" ? var.origin_path : null
    origin_access_control_id = var.create_oac ? aws_cloudfront_origin_access_control.this[0].id : null
  }

  default_cache_behavior {
    target_origin_id       = var.origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = local.cache_policy_id
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction.restriction_type
      locations        = var.geo_restriction.locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn == null
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = var.acm_certificate_arn != null ? "TLSv1.2_2021" : null
  }

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      bucket          = logging_config.value.bucket_domain_name
      prefix          = logging_config.value.prefix
      include_cookies = logging_config.value.include_cookies
    }
  }

  tags = var.tags
}

# Generate bucket policy for OAC
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "s3_bucket_policy" {
  count = var.create_oac ? 1 : 0

  statement {
    sid       = "AllowCloudFrontServicePrincipal"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${var.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}
