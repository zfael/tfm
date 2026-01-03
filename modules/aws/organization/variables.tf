variable "organizational_units" {
  description = "List of Organizational Units to create"
  type = list(object({
    name      = string
    parent_id = optional(string) # If null, uses org root
    tags      = optional(map(string), {})
  }))
  default = []
}

variable "service_control_policies" {
  description = "List of Service Control Policies to create and attach"
  type = list(object({
    name        = string
    description = optional(string)
    content     = string                     # JSON policy document
    targets     = optional(list(string), []) # OU IDs or account IDs to attach
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
