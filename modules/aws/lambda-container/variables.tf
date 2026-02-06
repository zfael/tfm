variable "name" {
  description = "Lambda function name"
  type        = string
}

variable "image_uri" {
  description = "ECR image URI (repo:tag)"
  type        = string
}

variable "memory_size" {
  description = "Memory in MB"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Timeout in seconds"
  type        = number
  default     = 30
}

variable "architectures" {
  description = "CPU architecture"
  type        = list(string)
  default     = ["arm64"]
}

variable "environment" {
  description = "Environment variables"
  type        = map(string)
  default     = {}
}

variable "vpc_config" {
  description = "VPC configuration"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "custom_policies" {
  description = "Custom IAM policy statements to attach to Lambda role"
  type = list(object({
    name   = string
    policy = string # JSON policy document
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
