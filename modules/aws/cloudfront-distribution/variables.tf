variable "origin_domain_name" {
  description = "Domain name of the S3 bucket origin"
  type        = string
}

variable "origin_id" {
  description = "Unique identifier for the origin"
  type        = string
}

variable "origin_path" {
  description = "Optional path to prepend to origin requests"
  type        = string
  default     = ""
}

variable "create_oac" {
  description = "Create Origin Access Control for S3"
  type        = bool
  default     = true
}

variable "oac_name" {
  description = "Name for the OAC (defaults to origin_id)"
  type        = string
  default     = null
}

variable "aliases" {
  description = "Custom domain names (CNAMEs) for the distribution"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for custom domain"
  type        = string
  default     = null
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

variable "enabled" {
  description = "Whether the distribution is enabled"
  type        = bool
  default     = true
}

variable "logging_config" {
  description = "Logging configuration"
  type = object({
    bucket_domain_name = string
    prefix             = optional(string, "")
    include_cookies    = optional(bool, false)
  })
  default = null
}

variable "cache_policy_id" {
  description = "Managed cache policy ID (use with custom_cache_policy = null)"
  type        = string
  default     = null
}

variable "custom_cache_policy" {
  description = "Custom cache policy settings"
  type = object({
    name        = string
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

variable "geo_restriction" {
  description = "Geographic restriction configuration"
  type = object({
    restriction_type = string
    locations        = list(string)
  })
  default = {
    restriction_type = "none"
    locations        = []
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
