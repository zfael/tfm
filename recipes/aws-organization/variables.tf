variable "organizational_units" {
  description = "List of Organizational Units to create"
  type = list(object({
    name      = string
    parent_id = optional(string)
    tags      = optional(map(string), {})
  }))
  default = []
}

variable "service_control_policies" {
  description = "List of Service Control Policies to create and attach"
  type = list(object({
    name        = string
    description = optional(string)
    content     = string
    targets     = optional(list(string), [])
  }))
  default = []
}

variable "accounts" {
  description = "List of AWS accounts to create"
  type = list(object({
    name                 = string
    email                = string
    ou_name              = string # Name of OU from organizational_units
    allow_billing_access = optional(bool, true)
    tags                 = optional(map(string), {})
  }))
  default = []
}

variable "users" {
  description = "List of Identity Center users"
  type = list(object({
    username     = string
    email        = string
    given_name   = string
    family_name  = string
    display_name = string
    assignments = optional(list(object({
      permission_set = string
      account_name   = string # References account name from accounts list
    })), [])
  }))
  default = []
}

variable "permission_sets" {
  description = "List of permission sets to create"
  type = list(object({
    name                = string
    description         = optional(string)
    session_duration    = optional(string, "PT4H")
    inline_policy       = optional(string)
    managed_policy_arns = optional(list(string), [])
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
