# AWS S3 Bucket Module

Creates an S3 bucket with versioning, CORS, lifecycle rules, and public access block.

## Usage

```hcl
module "bucket" {
  source = "github.com/zfael/tfm//modules/aws/s3-bucket"

  bucket_name        = "my-images-bucket"
  versioning_enabled = true
  force_destroy      = false

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

  tags = { Environment = "prod" }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `bucket_name` | Name of the S3 bucket | `string` | Yes |
| `force_destroy` | Allow destruction with objects | `bool` | No (default: false) |
| `versioning_enabled` | Enable versioning | `bool` | No (default: false) |
| `cors_rules` | CORS configuration | `list(object)` | No |
| `block_public_access` | Public access block settings | `object` | No (default: all true) |
| `lifecycle_rules` | Lifecycle rules | `list(object)` | No |
| `bucket_policy` | Bucket policy JSON | `string` | No |
| `tags` | Tags to apply | `map(string)` | No |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_id` | Bucket name |
| `bucket_arn` | Bucket ARN |
| `bucket_regional_domain_name` | Regional domain name |
| `bucket_domain_name` | Domain name |
