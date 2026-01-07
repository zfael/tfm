output "distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.arn
}

output "domain_name" {
  description = "The domain name of the distribution"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "hosted_zone_id" {
  description = "The CloudFront Route 53 zone ID"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "oac_id" {
  description = "The ID of the Origin Access Control"
  value       = var.create_oac ? aws_cloudfront_origin_access_control.this[0].id : null
}

output "s3_bucket_policy_json" {
  description = "IAM policy document to attach to the S3 origin bucket"
  value       = var.create_oac ? data.aws_iam_policy_document.s3_bucket_policy[0].json : null
}
