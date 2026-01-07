variable "bucket_name" {
  description = "Name of the content bucket"
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning on the content bucket"
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Allow bucket destruction with objects inside"
  type        = bool
  default     = false
}

variable "default_root_object" {
  description = "Default object to return for root requests"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "cors_rules" {
  description = "CORS configuration rules for content bucket"
  type = list(object({
    allowed_headers = optional(list(string), ["*"])
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string), [])
    max_age_seconds = optional(number, 3600)
  }))
  default = []
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for the content bucket"
  type = list(object({
    id      = string
    prefix  = optional(string, "")
    enabled = optional(bool, true)

    expiration_days                    = optional(number)
    noncurrent_version_expiration_days = optional(number)

    transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])

    noncurrent_version_transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
  }))
  default = []
}

variable "enable_logging" {
  description = "Enable CloudFront access logging"
  type        = bool
  default     = false
}

variable "logging_prefix" {
  description = "Prefix for CloudFront logs"
  type        = string
  default     = "cdn-logs/"
}

variable "logs_retention_days" {
  description = "Days to retain CloudFront logs"
  type        = number
  default     = 90
}

variable "cache_policy" {
  description = "Cache policy: CachingOptimized, CachingDisabled, or custom"
  type        = string
  default     = "CachingOptimized"

  validation {
    condition     = contains(["CachingOptimized", "CachingDisabled", "custom"], var.cache_policy)
    error_message = "cache_policy must be CachingOptimized, CachingDisabled, or custom"
  }
}

variable "custom_cache_ttl" {
  description = "Custom cache TTL settings (used when cache_policy = custom)"
  type = object({
    min_ttl     = optional(number, 0)
    default_ttl = optional(number, 86400)
    max_ttl     = optional(number, 31536000)
  })
  default = null
}

variable "custom_error_responses" {
  description = "Custom error response configurations"
  type = list(object({
    error_code            = number
    response_code         = optional(number)
    response_page_path    = optional(string)
    error_caching_min_ttl = optional(number)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
