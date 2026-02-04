variable "name" {
  description = "Repository name"
  type        = string
}

variable "image_tag_mutability" {
  description = "Tag mutability setting (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "Delete repository even if it contains images"
  type        = bool
  default     = false
}

variable "max_image_count" {
  description = "Max images to keep (0 to disable default lifecycle)"
  type        = number
  default     = 10
}

variable "lifecycle_policy" {
  description = "Custom lifecycle policy JSON (overrides max_image_count)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
