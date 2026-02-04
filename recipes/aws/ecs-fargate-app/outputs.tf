# ECR
output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ECR repository ARN"
  value       = module.ecr.repository_arn
}

# ECS Cluster
output "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  value       = module.ecs_cluster.arn
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs_cluster.name
}

# ALB
output "alb_arn" {
  description = "ALB ARN"
  value       = module.alb.arn
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.dns_name
}

output "alb_zone_id" {
  description = "ALB hosted zone ID"
  value       = module.alb.zone_id
}

# Target Group
output "target_group_arn" {
  description = "Target group ARN"
  value       = module.target_group.arn
}

# Task Definition
output "task_definition_arn" {
  description = "Task definition ARN"
  value       = module.task_definition.arn
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = module.task_definition.log_group_name
}

# ECS Service
output "ecs_service_id" {
  description = "ECS service ID"
  value       = module.ecs_service.id
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs_service.name
}

# IAM Roles
output "execution_role_arn" {
  description = "Task execution role ARN"
  value       = aws_iam_role.execution.arn
}

output "task_role_arn" {
  description = "Task role ARN"
  value       = aws_iam_role.task.arn
}
