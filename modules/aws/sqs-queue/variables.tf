variable "name" {
  description = "Queue name"
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout (should be >= Lambda timeout)"
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "Message retention period"
  type        = number
  default     = 345600 # 4 days
}

variable "delay_seconds" {
  description = "Delay before message becomes visible"
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "Max message size in bytes"
  type        = number
  default     = 262144 # 256 KB
}

variable "receive_wait_time_seconds" {
  description = "Long polling wait time"
  type        = number
  default     = 0
}

variable "create_dlq" {
  description = "Create a dead-letter queue"
  type        = bool
  default     = true
}

variable "dlq_arn" {
  description = "External DLQ ARN (if not creating one)"
  type        = string
  default     = null
}

variable "dlq_retention_seconds" {
  description = "DLQ message retention period"
  type        = number
  default     = 1209600 # 14 days
}

variable "max_receive_count" {
  description = "Max receives before sending to DLQ"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
