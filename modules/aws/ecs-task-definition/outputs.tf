output "arn" {
  description = "Task definition ARN"
  value       = aws_ecs_task_definition.this.arn
}

output "family" {
  description = "Task definition family"
  value       = aws_ecs_task_definition.this.family
}

output "revision" {
  description = "Task definition revision"
  value       = aws_ecs_task_definition.this.revision
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = var.create_log_group ? aws_cloudwatch_log_group.this[0].name : var.log_group_name
}
