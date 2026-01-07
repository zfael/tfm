# Custom Cache Policy

resource "aws_cloudfront_cache_policy" "this" {
  count = var.custom_cache_policy != null ? 1 : 0

  name        = var.custom_cache_policy.name
  min_ttl     = var.custom_cache_policy.min_ttl
  default_ttl = var.custom_cache_policy.default_ttl
  max_ttl     = var.custom_cache_policy.max_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}
