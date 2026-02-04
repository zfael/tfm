output "id" {
  description = "Security group ID"
  value       = module.sg.id
}

output "arn" {
  description = "Security group ARN"
  value       = module.sg.arn
}

output "name" {
  description = "Security group name"
  value       = module.sg.name
}
