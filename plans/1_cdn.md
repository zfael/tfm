# AWS CDN Implementation Plan

## Overview
Create individual AWS service modules for CDN components, then bundle them into a CDN recipe. Domain/SSL setup will be handled separately later.

## Architecture
```
Phase 1 (now): CloudFront + S3 (origin) + OAC
Phase 2 (later): Add ACM + Route53 for custom domain
```

---

## Modules to Create

| Module | Purpose | Key Resources |
|--------|---------|---------------|
| `modules/aws/s3-bucket` | Origin bucket for images | `aws_s3_bucket`, bucket policy, CORS, lifecycle rules |
| `modules/aws/cloudfront-distribution` | CDN distribution | `aws_cloudfront_distribution`, OAC |

---

## Recipe to Create

| Recipe | Purpose | Modules Wired |
|--------|---------|---------------|
| `recipes/aws/cdn` | Complete CDN setup | s3-bucket → cloudfront-distribution (+ internal logs bucket) |

---

## Module Specifications

### 1. `modules/aws/s3-bucket`
**Inputs:**
- `bucket_name` - bucket name
- `force_destroy` - allow destroy with objects (optional, default false)
- `versioning_enabled` - enable versioning (optional, default false)
- `cors_rules` - CORS config (optional)
- `block_public_access` - block public access settings (optional, default all true)
- `lifecycle_rules` - list of lifecycle rules (optional)
  - `id`, `prefix`, `enabled`
  - `expiration_days`, `noncurrent_version_expiration_days`
  - `transition` (storage class changes)
- `tags`

**Outputs:**
- `bucket_id`, `bucket_arn`, `bucket_regional_domain_name`

---

### 2. `modules/aws/cloudfront-distribution`
**Inputs:**
- `origin_domain_name` - S3 bucket domain
- `origin_id` - origin identifier
- `create_oac` - create OAC for S3 (optional, default true)
- `oac_name` - OAC name (optional, defaults to origin_id)
- `aliases` - custom domains (optional, for future use)
- `acm_certificate_arn` - SSL cert (optional, for future use)
- `default_root_object` - (optional, default "index.html")
- `price_class` - (optional, default PriceClass_100)
- `logging_config` - (optional) { bucket_domain_name, prefix }
- `cache_policy_id` - (optional, default: CachingOptimized)
- `custom_cache_policy` - (optional) { min_ttl, default_ttl, max_ttl }
- `custom_error_responses` - (optional)
- `tags`

**Outputs:**
- `distribution_id`, `distribution_arn`, `domain_name`, `hosted_zone_id`, `oac_id`
- `s3_bucket_policy_json` - policy doc to attach to origin bucket

---

## Recipe Specification

### `recipes/aws/cdn`
**Purpose:** CDN for static content (images)

**Inputs:**
- `bucket_name` - content bucket name
- `versioning_enabled` - (optional, default false)
- `force_destroy` - (optional, default false)
- `default_root_object` - (optional)
- `price_class` - (optional, default PriceClass_100)
- `cors_rules` - (optional)
- `lifecycle_rules` - (optional) for content bucket
- `enable_logging` - (optional, default false)
- `logging_prefix` - (optional, default "cdn-logs/")
- `logs_retention_days` - (optional, default 90)
- `cache_policy` - (optional, "CachingOptimized" | "CachingDisabled" | "custom")
- `custom_cache_ttl` - (optional) { min_ttl, default_ttl, max_ttl }
- `custom_error_responses` - (optional)
- `tags`

**Future Inputs (Phase 2):**
- `domain_name` - custom domain
- `zone_id` - Route53 zone
- `certificate_arn` - ACM cert

**Outputs:**
- `bucket_id`, `bucket_arn`
- `distribution_id`, `distribution_domain_name`
- `cdn_url` - CloudFront URL
- `logs_bucket_id` - (if logging enabled)

**Internal Logic:**
- Creates content bucket via `s3-bucket` module
- If `enable_logging = true`, creates internal logs bucket with:
  - Name: `${bucket_name}-logs`
  - ACL: `log-delivery-write` (for CloudFront)
  - Lifecycle: expire after `logs_retention_days`
- Creates CloudFront distribution via `cloudfront-distribution` module
- Attaches OAC bucket policy to content bucket

---

## File Structure
```
tfm/
├── modules/aws/
│   ├── s3-bucket/
│   │   ├── main.tf
│   │   ├── lifecycle.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── versions.tf
│   │   └── README.md
│   └── cloudfront-distribution/
│       ├── main.tf
│       ├── oac.tf
│       ├── cache.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       └── README.md
└── recipes/aws/
    └── cdn/
        ├── main.tf
        ├── logs.tf          # internal logs bucket
        ├── variables.tf
        ├── outputs.tf
        ├── versions.tf
        └── README.md
```

---

## Implementation Order
1. `modules/aws/s3-bucket`
2. `modules/aws/cloudfront-distribution`
3. `recipes/aws/cdn`

---

## Why Lambda@Edge Would Be Valuable (Future)

Lambda@Edge runs code at CloudFront edge locations:

| Use Case | Benefit |
|----------|---------|
| **Image resizing on-the-fly** | Serve thumbnails/retina from single source |
| **Format conversion** | Auto WebP/AVIF based on browser |
| **URL rewriting** | Clean URLs, redirects |
| **Auth at edge** | Token validation before origin |
| **Custom headers** | Security headers without origin changes |

For image CDN: store one high-res image → generate variants on demand → reduce storage costs.

---

## Caching Strategy

Default: AWS managed `CachingOptimized` policy (1 year TTL, ideal for immutable images).

Custom option available via `custom_cache_ttl` if needed.

---

## Phase 2 Modules (Later)

| Module | Purpose |
|--------|---------|
| `modules/aws/acm-certificate` | SSL cert with DNS validation (supports wildcards) |
| `modules/aws/route53-record` | Alias records to CloudFront |
