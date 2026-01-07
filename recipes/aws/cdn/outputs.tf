output "bucket_id" {
  description = "Content bucket name"
  value       = module.content_bucket.bucket_id
}

output "bucket_arn" {
  description = "Content bucket ARN"
  value       = module.content_bucket.bucket_arn
}

output "distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.distribution_id
}

output "distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = module.cloudfront.distribution_arn
}

output "distribution_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.cloudfront.domain_name
}

output "cdn_url" {
  description = "Full CDN URL"
  value       = "https://${module.cloudfront.domain_name}"
}

output "hosted_zone_id" {
  description = "CloudFront Route 53 zone ID (for custom domain setup)"
  value       = module.cloudfront.hosted_zone_id
}

output "logs_bucket_id" {
  description = "Logs bucket name (if logging enabled)"
  value       = var.enable_logging ? module.logs_bucket[0].bucket_id : null
}
