output "arn" {
  description = "Certificate ARN"
  value       = aws_acm_certificate.this.arn
}

output "domain_name" {
  description = "Primary domain name"
  value       = aws_acm_certificate.this.domain_name
}

output "validation_complete" {
  description = "Certificate validation resource (use for dependencies)"
  value       = aws_acm_certificate_validation.this.id
}
