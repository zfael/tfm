# Required
variable "name" {
  description = "Application name (used for all resources)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB and ECS tasks"
  type        = list(string)
}

variable "alb_security_group_ids" {
  description = "Security group IDs for ALB"
  type        = list(string)
}

variable "ecs_security_group_ids" {
  description = "Security group IDs for ECS tasks"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

# Optional - ECR
variable "ecr_force_delete" {
  description = "Force delete ECR repo"
  type        = bool
  default     = false
}

variable "ecr_lifecycle_count" {
  description = "Number of images to keep"
  type        = number
  default     = 10
}

# Optional - ECS Cluster
variable "cluster_name" {
  description = "ECS cluster name (defaults to var.name)"
  type        = string
  default     = null
}

variable "container_insights" {
  description = "Enable CloudWatch Container Insights"
  type        = bool
  default     = false
}

# Optional - Task
variable "cpu" {
  description = "Task CPU units"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Task memory in MB"
  type        = number
  default     = 512
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}

variable "environment" {
  description = "Environment variables"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secrets from SSM (name -> SSM ARN)"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch log retention"
  type        = number
  default     = 30
}

variable "container_health_check" {
  description = "Container health check"
  type = object({
    command      = list(string)
    interval     = optional(number, 30)
    timeout      = optional(number, 5)
    retries      = optional(number, 3)
    start_period = optional(number, 60)
  })
  default = null
}

# Optional - Service
variable "desired_count" {
  description = "Desired task count"
  type        = number
  default     = 1
}

# Optional - ALB Health Check
variable "health_check_path" {
  description = "ALB health check path"
  type        = string
  default     = "/health"
}

variable "health_check_matcher" {
  description = "ALB health check success codes"
  type        = string
  default     = "200"
}

# Optional - IAM
variable "s3_bucket_arn" {
  description = "S3 bucket ARN for task role access"
  type        = string
  default     = null
}

variable "task_ssm_parameters" {
  description = "SSM parameter ARNs for task role read access"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
