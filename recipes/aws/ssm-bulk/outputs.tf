output "parameter_arns" {
  description = "Map of parameter keys to their ARNs"
  value       = { for k, v in module.params : k => v.arn }
}

output "parameter_names" {
  description = "Map of parameter keys to their full SSM names"
  value       = { for k, v in module.params : k => v.name }
}

output "arn_pattern" {
  description = "ARN pattern for IAM policies"
  value       = "arn:aws:ssm:*:*:parameter/${var.prefix}/*"
}
