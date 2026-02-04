variable "type" {
  description = "Type of rule: ingress or egress"
  type        = string

  validation {
    condition     = contains(["ingress", "egress"], var.type)
    error_message = "Type must be 'ingress' or 'egress'"
  }
}

variable "security_group_id" {
  description = "Security group ID to attach rule to"
  type        = string
}

variable "from_port" {
  description = "Start port (0 for all)"
  type        = number
}

variable "to_port" {
  description = "End port (0 for all)"
  type        = number
}

variable "protocol" {
  description = "Protocol (tcp, udp, icmp, -1 for all)"
  type        = string
}

variable "cidr_blocks" {
  description = "List of CIDR blocks"
  type        = list(string)
  default     = null
}

variable "ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR blocks"
  type        = list(string)
  default     = null
}

variable "source_security_group_id" {
  description = "Source security group ID (for SG-to-SG rules)"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the rule"
  type        = string
  default     = null
}
