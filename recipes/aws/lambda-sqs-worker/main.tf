# Lambda SQS Worker Recipe
#
# Composes: ECR, SQS queue (with DLQ), container Lambda, IAM policies,
# and SQS event source mapping.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # SQS policy is always added
  sqs_policy = {
    name = "sqs-access"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
        ]
        Resource = [module.sqs.arn]
      }]
    })
  }

  # Combine SQS policy with caller's custom policies
  all_policies = concat([local.sqs_policy], var.custom_policies)
}

# -----------------------------------------------------------------------------
# ECR Repository
# -----------------------------------------------------------------------------
module "ecr" {
  source = "../../../modules/aws/ecr"

  name                 = var.name
  image_tag_mutability = "MUTABLE"
  force_delete         = var.ecr_force_delete
  max_image_count      = var.ecr_max_image_count
  tags                 = var.tags
}

# -----------------------------------------------------------------------------
# SQS Queue
# -----------------------------------------------------------------------------
module "sqs" {
  source = "../../../modules/aws/sqs-queue"

  name                       = var.name
  visibility_timeout_seconds = var.sqs_visibility_timeout
  message_retention_seconds  = var.sqs_message_retention
  create_dlq                 = true
  max_receive_count          = var.sqs_max_receive_count
  dlq_retention_seconds      = var.sqs_dlq_retention
  tags                       = var.tags
}

# -----------------------------------------------------------------------------
# Lambda Function
# -----------------------------------------------------------------------------
module "lambda" {
  source = "../../../modules/aws/lambda-container"

  name            = var.name
  image_uri       = "${module.ecr.repository_url}:${var.image_tag}"
  memory_size     = var.lambda_memory
  timeout         = var.lambda_timeout
  environment     = var.environment
  vpc_config      = var.vpc_config
  custom_policies = local.all_policies
  tags            = var.tags
}

# -----------------------------------------------------------------------------
# SQS Event Source Mapping
# -----------------------------------------------------------------------------
resource "aws_lambda_event_source_mapping" "sqs" {
  event_source_arn = module.sqs.arn
  function_name    = module.lambda.arn
  batch_size       = var.sqs_batch_size
  enabled          = true
}
