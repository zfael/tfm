# ECR
output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "ecr_repository_arn" {
  description = "ECR repository ARN"
  value       = module.ecr.repository_arn
}

# SQS
output "sqs_queue_url" {
  description = "SQS queue URL"
  value       = module.sqs.url
}

output "sqs_queue_arn" {
  description = "SQS queue ARN"
  value       = module.sqs.arn
}

output "sqs_dlq_arn" {
  description = "SQS dead-letter queue ARN"
  value       = module.sqs.dlq_arn
}

# Lambda
output "lambda_arn" {
  description = "Lambda function ARN"
  value       = module.lambda.arn
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = module.lambda.function_name
}

output "lambda_role_arn" {
  description = "Lambda IAM role ARN"
  value       = module.lambda.role_arn
}

output "lambda_role_name" {
  description = "Lambda IAM role name"
  value       = module.lambda.role_name
}
