output "id" {
  description = "Cluster ID"
  value       = aws_ecs_cluster.this.id
}

output "arn" {
  description = "Cluster ARN"
  value       = aws_ecs_cluster.this.arn
}

output "name" {
  description = "Cluster name"
  value       = aws_ecs_cluster.this.name
}
