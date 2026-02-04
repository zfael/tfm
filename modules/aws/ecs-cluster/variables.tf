variable "name" {
  description = "Cluster name"
  type        = string
}

variable "container_insights" {
  description = "Enable CloudWatch Container Insights"
  type        = bool
  default     = false
}

variable "capacity_providers" {
  description = "List of capacity providers (FARGATE, FARGATE_SPOT)"
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "default_capacity_provider_strategy" {
  description = "Default capacity provider strategy"
  type = list(object({
    capacity_provider = string
    weight            = optional(number, 1)
    base              = optional(number, 0)
  }))
  default = [{
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 0
  }]
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
