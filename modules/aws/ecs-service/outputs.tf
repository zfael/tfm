output "id" {
  description = "Service ID"
  value       = aws_ecs_service.this.id
}

output "name" {
  description = "Service name"
  value       = aws_ecs_service.this.name
}

output "cluster" {
  description = "Cluster ARN"
  value       = aws_ecs_service.this.cluster
}
