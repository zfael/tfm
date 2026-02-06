variable "name" {
  description = "Name for all resources"
  type        = string
}

# ECR
variable "ecr_force_delete" {
  description = "Delete ECR even with images"
  type        = bool
  default     = false
}

variable "ecr_max_image_count" {
  description = "Max images to retain in ECR"
  type        = number
  default     = 3
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}

# SQS
variable "sqs_visibility_timeout" {
  description = "SQS visibility timeout (should be >= lambda timeout)"
  type        = number
  default     = 300
}

variable "sqs_message_retention" {
  description = "SQS message retention in seconds"
  type        = number
  default     = 86400 # 1 day
}

variable "sqs_max_receive_count" {
  description = "Max receives before DLQ"
  type        = number
  default     = 3
}

variable "sqs_dlq_retention" {
  description = "DLQ message retention in seconds"
  type        = number
  default     = 1209600 # 14 days
}

variable "sqs_batch_size" {
  description = "SQS batch size for Lambda"
  type        = number
  default     = 1
}

# Lambda
variable "lambda_memory" {
  description = "Lambda memory in MB"
  type        = number
  default     = 512
}

variable "lambda_timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 120
}

variable "environment" {
  description = "Lambda environment variables"
  type        = map(string)
  default     = {}
}

variable "vpc_config" {
  description = "VPC configuration for Lambda"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

# Custom IAM policies
variable "custom_policies" {
  description = "Custom IAM policies to attach to Lambda role"
  type = list(object({
    name   = string
    policy = string # JSON policy document
  }))
  default = []
}

# Tags
variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
