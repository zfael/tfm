# Origin Access Control

resource "aws_cloudfront_origin_access_control" "this" {
  count = var.create_oac ? 1 : 0

  name                              = coalesce(var.oac_name, var.origin_id)
  description                       = "OAC for ${var.origin_id}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
