variable "name" {
  description = "Service name"
  type        = string
}

variable "cluster_arn" {
  description = "ECS cluster ARN"
  type        = string
}

variable "task_definition_arn" {
  description = "Task definition ARN"
  type        = string
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "Subnet IDs for tasks"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for tasks"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks"
  type        = bool
  default     = true
}

variable "target_group_arn" {
  description = "ALB target group ARN (optional)"
  type        = string
  default     = null
}

variable "container_name" {
  description = "Container name for load balancer"
  type        = string
}

variable "container_port" {
  description = "Container port for load balancer"
  type        = number
}

variable "deployment_circuit_breaker" {
  description = "Enable deployment circuit breaker"
  type        = bool
  default     = true
}

variable "deployment_maximum_percent" {
  description = "Max percent of tasks during deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Min percent of healthy tasks during deployment"
  type        = number
  default     = 100
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
