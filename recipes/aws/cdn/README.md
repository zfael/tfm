# AWS CDN Recipe

Complete CDN setup with CloudFront, S3 origin, and OAC.

## Usage

```hcl
module "cdn" {
  source = "github.com/zfael/tfm//recipes/aws/cdn"

  bucket_name        = "my-images-cdn"
  versioning_enabled = true
  price_class        = "PriceClass_100"

  cors_rules = [
    {
      allowed_methods = ["GET", "HEAD"]
      allowed_origins = ["https://example.com"]
    }
  ]

  lifecycle_rules = [
    {
      id = "optimize-storage"
      transitions = [
        { days = 30, storage_class = "STANDARD_IA" },
        { days = 90, storage_class = "GLACIER_IR" }
      ]
    }
  ]

  enable_logging      = true
  logs_retention_days = 30

  tags = { Environment = "prod" }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `bucket_name` | Content bucket name | `string` | Yes |
| `versioning_enabled` | Enable versioning | `bool` | No (default: false) |
| `force_destroy` | Allow destruction with objects | `bool` | No (default: false) |
| `default_root_object` | Default root object | `string` | No (default: index.html) |
| `price_class` | CloudFront price class | `string` | No (default: PriceClass_100) |
| `cors_rules` | CORS configuration | `list(object)` | No |
| `lifecycle_rules` | Lifecycle rules | `list(object)` | No |
| `enable_logging` | Enable CloudFront logging | `bool` | No (default: false) |
| `logging_prefix` | Log prefix | `string` | No (default: cdn-logs/) |
| `logs_retention_days` | Log retention | `number` | No (default: 90) |
| `cache_policy` | Cache policy | `string` | No (default: CachingOptimized) |
| `custom_cache_ttl` | Custom TTL settings | `object` | No |
| `custom_error_responses` | Custom error responses | `list(object)` | No |
| `tags` | Tags to apply | `map(string)` | No |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_id` | Content bucket name |
| `bucket_arn` | Content bucket ARN |
| `distribution_id` | CloudFront distribution ID |
| `distribution_arn` | CloudFront distribution ARN |
| `distribution_domain_name` | CloudFront domain |
| `cdn_url` | Full CDN URL |
| `hosted_zone_id` | Route 53 zone ID |
| `logs_bucket_id` | Logs bucket (if enabled) |

## Architecture

```
User → CloudFront (OAC) → S3 Content Bucket
                    ↘
                     S3 Logs Bucket (optional)
```

## Phase 2 (Future)

Custom domain support via ACM + Route53 modules.
