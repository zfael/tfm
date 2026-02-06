# Lambda Container Module
#
# Creates a container-based Lambda function with IAM role.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# IAM Role for Lambda
resource "aws_iam_role" "this" {
  name = "${var.name}-lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

# Basic execution policy (CloudWatch logs)
resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# VPC access if enabled
resource "aws_iam_role_policy_attachment" "vpc" {
  count      = var.vpc_config != null ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Custom policies
resource "aws_iam_role_policy" "custom" {
  for_each = { for p in var.custom_policies : p.name => p }

  name   = each.value.name
  role   = aws_iam_role.this.name
  policy = each.value.policy
}

# Lambda Function
resource "aws_lambda_function" "this" {
  function_name = var.name
  package_type  = "Image"
  image_uri     = var.image_uri
  role          = aws_iam_role.this.arn

  memory_size = var.memory_size
  timeout     = var.timeout

  architectures = var.architectures

  dynamic "environment" {
    for_each = length(var.environment) > 0 ? [1] : []
    content {
      variables = var.environment
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids         = vpc_config.value.subnet_ids
      security_group_ids = vpc_config.value.security_group_ids
    }
  }

  lifecycle {
    ignore_changes = [image_uri]
  }

  tags = var.tags
}
