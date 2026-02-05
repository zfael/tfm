output "arn" {
  description = "Parameter ARN"
  value       = aws_ssm_parameter.this.arn
}

output "name" {
  description = "Parameter name"
  value       = aws_ssm_parameter.this.name
}
