# CDN Recipe - Main Configuration

locals {
  # AWS managed cache policy IDs
  cache_policy_ids = {
    CachingOptimized = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    CachingDisabled  = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }

  cache_policy_id = var.cache_policy != "custom" ? local.cache_policy_ids[var.cache_policy] : null

  custom_cache_policy = var.cache_policy == "custom" && var.custom_cache_ttl != null ? {
    name        = "${var.bucket_name}-cache-policy"
    min_ttl     = var.custom_cache_ttl.min_ttl
    default_ttl = var.custom_cache_ttl.default_ttl
    max_ttl     = var.custom_cache_ttl.max_ttl
  } : null
}

# Content Bucket
module "content_bucket" {
  source = "../../../modules/aws/s3-bucket"

  bucket_name        = var.bucket_name
  versioning_enabled = var.versioning_enabled
  force_destroy      = var.force_destroy
  cors_rules         = var.cors_rules
  lifecycle_rules    = var.lifecycle_rules
  bucket_policy      = module.cloudfront.s3_bucket_policy_json
  tags               = var.tags
}

# CloudFront Distribution
module "cloudfront" {
  source = "../../../modules/aws/cloudfront-distribution"

  origin_domain_name  = module.content_bucket.bucket_regional_domain_name
  origin_id           = var.bucket_name
  default_root_object = var.default_root_object
  price_class         = var.price_class

  cache_policy_id     = local.cache_policy_id
  custom_cache_policy = local.custom_cache_policy

  custom_error_responses = var.custom_error_responses

  logging_config = var.enable_logging ? {
    bucket_domain_name = module.logs_bucket[0].bucket_domain_name
    prefix             = var.logging_prefix
  } : null

  tags = var.tags
}
