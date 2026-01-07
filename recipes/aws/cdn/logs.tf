# Logs Bucket for CloudFront Access Logs

module "logs_bucket" {
  source = "../../../modules/aws/s3-bucket"
  count  = var.enable_logging ? 1 : 0

  bucket_name   = "${var.bucket_name}-logs"
  force_destroy = var.force_destroy

  # CloudFront logging requires ACL, but we block other public access
  block_public_access = {
    block_public_acls       = false
    block_public_policy     = true
    ignore_public_acls      = false
    restrict_public_buckets = true
  }

  lifecycle_rules = [
    {
      id              = "expire-logs"
      enabled         = true
      expiration_days = var.logs_retention_days
    }
  ]

  tags = merge(var.tags, { Purpose = "cloudfront-logs" })
}

# CloudFront requires ACL for logging bucket
resource "aws_s3_bucket_acl" "logs" {
  count  = var.enable_logging ? 1 : 0
  bucket = module.logs_bucket[0].bucket_id
  acl    = "log-delivery-write"

  depends_on = [aws_s3_bucket_ownership_controls.logs]
}

resource "aws_s3_bucket_ownership_controls" "logs" {
  count  = var.enable_logging ? 1 : 0
  bucket = module.logs_bucket[0].bucket_id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
