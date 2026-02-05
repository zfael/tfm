variable "load_balancer_arn" {
  description = "ALB ARN"
  type        = string
}

variable "port" {
  description = "Listener port"
  type        = number
}

variable "protocol" {
  description = "Listener protocol (HTTP or HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listeners"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listeners"
  type        = string
  default     = null
}

variable "default_action_type" {
  description = "Default action type (forward, redirect, fixed-response)"
  type        = string
  default     = "forward"
}

variable "target_group_arn" {
  description = "Target group ARN for forward action"
  type        = string
  default     = null
}

# Redirect action variables
variable "redirect_port" {
  description = "Redirect port"
  type        = string
  default     = "443"
}

variable "redirect_protocol" {
  description = "Redirect protocol"
  type        = string
  default     = "HTTPS"
}

variable "redirect_status_code" {
  description = "Redirect status code"
  type        = string
  default     = "HTTP_301"
}

# Fixed response variables
variable "fixed_response_content_type" {
  description = "Fixed response content type"
  type        = string
  default     = "text/plain"
}

variable "fixed_response_message_body" {
  description = "Fixed response message body"
  type        = string
  default     = ""
}

variable "fixed_response_status_code" {
  description = "Fixed response status code"
  type        = string
  default     = "200"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
