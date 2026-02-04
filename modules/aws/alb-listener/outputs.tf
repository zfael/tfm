output "arn" {
  description = "Listener ARN"
  value       = aws_lb_listener.this.arn
}

output "id" {
  description = "Listener ID"
  value       = aws_lb_listener.this.id
}
