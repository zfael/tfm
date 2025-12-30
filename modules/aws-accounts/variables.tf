variable "accounts" {
  description = "List of AWS accounts to create"
  type = list(object({
    name                 = string
    email                = string
    parent_id            = string # OU ID where account will be placed
    allow_billing_access = optional(bool, true)
    tags                 = optional(map(string), {})
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all accounts"
  type        = map(string)
  default     = {}
}
