variable "domain_name" {
  description = "Primary domain name for the certificate"
  type        = string
}

variable "alternative_names" {
  description = "List of subject alternative names (e.g., [\"*.example.com\"])"
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "Route53 hosted zone ID for DNS validation"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
