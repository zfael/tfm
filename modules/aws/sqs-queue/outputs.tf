output "arn" {
  description = "Queue ARN"
  value       = aws_sqs_queue.this.arn
}

output "url" {
  description = "Queue URL"
  value       = aws_sqs_queue.this.url
}

output "name" {
  description = "Queue name"
  value       = aws_sqs_queue.this.name
}

output "dlq_arn" {
  description = "Dead-letter queue ARN"
  value       = var.create_dlq ? aws_sqs_queue.dlq[0].arn : null
}

output "dlq_url" {
  description = "Dead-letter queue URL"
  value       = var.create_dlq ? aws_sqs_queue.dlq[0].url : null
}
