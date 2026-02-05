variable "family" {
  description = "Task definition family name"
  type        = string
}

variable "cpu" {
  description = "CPU units (256, 512, 1024, 2048, 4096)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory in MB (512, 1024, 2048, etc.)"
  type        = number
  default     = 512
}

variable "execution_role_arn" {
  description = "Task execution role ARN (for ECR pull, logs)"
  type        = string
}

variable "task_role_arn" {
  description = "Task role ARN (for app permissions)"
  type        = string
  default     = null
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_image" {
  description = "Container image URI"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "environment" {
  description = "Environment variables (key-value map)"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secrets from SSM/Secrets Manager (name -> ARN map)"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "AWS region for logs"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
  default     = null
}

variable "create_log_group" {
  description = "Create CloudWatch log group"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Log retention in days"
  type        = number
  default     = 30
}

variable "health_check" {
  description = "Container health check configuration"
  type = object({
    command      = list(string)
    interval     = optional(number, 30)
    timeout      = optional(number, 5)
    retries      = optional(number, 3)
    start_period = optional(number, 60)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
