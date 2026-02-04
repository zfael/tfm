output "arn" {
  description = "ALB ARN"
  value       = aws_lb.this.arn
}

output "dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "zone_id" {
  description = "ALB hosted zone ID (for Route53 alias)"
  value       = aws_lb.this.zone_id
}

output "id" {
  description = "ALB ID"
  value       = aws_lb.this.id
}
