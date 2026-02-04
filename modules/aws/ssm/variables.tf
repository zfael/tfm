variable "name" {
  description = "Full parameter name (e.g., /my-app/db/url)"
  type        = string
}

variable "value" {
  description = "Parameter value"
  type        = string
  sensitive   = true
}

variable "secure" {
  description = "If true, creates SecureString. If false, creates String."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "Optional KMS key ID for SecureString encryption"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
