variable "name" {
  description = "ALB name"
  type        = string
}

variable "internal" {
  description = "Whether ALB is internal (true) or internet-facing (false)"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "Security group IDs to attach"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnet IDs for the ALB"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
