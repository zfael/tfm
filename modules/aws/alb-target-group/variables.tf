variable "name" {
  description = "Target group name"
  type        = string
}

variable "port" {
  description = "Port for targets"
  type        = number
}

variable "protocol" {
  description = "Protocol (HTTP or HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "target_type" {
  description = "Target type (instance, ip, lambda, alb)"
  type        = string
  default     = "ip"
}

variable "health_check" {
  description = "Health check configuration"
  type = object({
    healthy_threshold   = optional(number, 2)
    unhealthy_threshold = optional(number, 3)
    timeout             = optional(number, 5)
    interval            = optional(number, 30)
    path                = optional(string, "/")
    port                = optional(string, "traffic-port")
    protocol            = optional(string, "HTTP")
    matcher             = optional(string, "200")
  })
  default = {}
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
