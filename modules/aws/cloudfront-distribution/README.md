# AWS CloudFront Distribution Module

Creates a CloudFront distribution with OAC for S3 origins.

## Usage

```hcl
module "cloudfront" {
  source = "github.com/zfael/tfm//modules/aws/cloudfront-distribution"

  origin_domain_name = module.bucket.bucket_regional_domain_name
  origin_id          = "my-s3-origin"
  price_class        = "PriceClass_100"

  tags = { Environment = "prod" }
}

# Attach the generated bucket policy
resource "aws_s3_bucket_policy" "origin" {
  bucket = module.bucket.bucket_id
  policy = module.cloudfront.s3_bucket_policy_json
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `origin_domain_name` | S3 bucket regional domain | `string` | Yes |
| `origin_id` | Unique origin identifier | `string` | Yes |
| `origin_path` | Path to prepend to requests | `string` | No |
| `create_oac` | Create OAC for S3 | `bool` | No (default: true) |
| `oac_name` | OAC name | `string` | No (default: origin_id) |
| `aliases` | Custom domain names | `list(string)` | No |
| `acm_certificate_arn` | ACM certificate ARN | `string` | No |
| `default_root_object` | Default root object | `string` | No (default: index.html) |
| `price_class` | Price class | `string` | No (default: PriceClass_100) |
| `enabled` | Enable distribution | `bool` | No (default: true) |
| `logging_config` | Logging settings | `object` | No |
| `cache_policy_id` | Managed cache policy ID | `string` | No |
| `custom_cache_policy` | Custom cache policy | `object` | No |
| `custom_error_responses` | Custom error responses | `list(object)` | No |
| `geo_restriction` | Geo restriction | `object` | No (default: none) |
| `tags` | Tags to apply | `map(string)` | No |

## Outputs

| Name | Description |
|------|-------------|
| `distribution_id` | Distribution ID |
| `distribution_arn` | Distribution ARN |
| `domain_name` | CloudFront domain name |
| `hosted_zone_id` | Route 53 zone ID |
| `oac_id` | Origin Access Control ID |
| `s3_bucket_policy_json` | Policy to attach to S3 bucket |
