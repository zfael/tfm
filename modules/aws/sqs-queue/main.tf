# SQS Queue Module
#
# Creates an SQS queue with optional dead-letter queue.

resource "aws_sqs_queue" "dlq" {
  count = var.create_dlq ? 1 : 0

  name                      = "${var.name}-dlq"
  message_retention_seconds = var.dlq_retention_seconds

  tags = var.tags
}

resource "aws_sqs_queue" "this" {
  name                       = var.name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  delay_seconds              = var.delay_seconds
  max_message_size           = var.max_message_size
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  dynamic "redrive_policy" {
    for_each = var.create_dlq ? [1] : []
    content {
      deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
      maxReceiveCount     = var.max_receive_count
    }
  }

  # Use external DLQ if provided
  dynamic "redrive_policy" {
    for_each = var.dlq_arn != null && !var.create_dlq ? [1] : []
    content {
      deadLetterTargetArn = var.dlq_arn
      maxReceiveCount     = var.max_receive_count
    }
  }

  tags = var.tags
}
