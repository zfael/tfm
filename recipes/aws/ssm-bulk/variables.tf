variable "prefix" {
  description = "Prefix for all parameter names (e.g., 'my-app' creates '/my-app/...')"
  type        = string
}

variable "parameters" {
  description = "Map of parameters. Key = path suffix, value = { value, secure (optional) }"
  type = map(object({
    value  = string
    secure = optional(bool, false)
  }))
}

variable "kms_key_id" {
  description = "Optional KMS key ID for SecureString parameters"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all parameters"
  type        = map(string)
  default     = {}
}
