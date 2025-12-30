variable "users" {
  description = "List of Identity Center users to create"
  type = list(object({
    username     = string
    email        = string
    given_name   = string
    family_name  = string
    display_name = string
    assignments  = optional(list(object({
      permission_set = string  # Must match a name in permission_sets
      account_id     = string  # AWS account ID
    })), [])
  }))
  default = []
}

variable "permission_sets" {
  description = "List of permission sets to create"
  type = list(object({
    name                = string
    description         = optional(string)
    session_duration    = optional(string, "PT4H") # ISO 8601 duration
    inline_policy       = optional(string)         # JSON policy document
    managed_policy_arns = optional(list(string), [])
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
