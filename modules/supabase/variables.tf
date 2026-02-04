variable "organization_id" {
  description = "Supabase organization ID (get from Supabase dashboard: Settings > General)"
  type        = string
}

variable "project_name" {
  description = "Name for the Supabase project"
  type        = string
}

variable "database_password" {
  description = "Password for the Supabase PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Supabase region"
  type        = string
  default     = "us-east-1"

  validation {
    condition = contains([
      "us-east-1",
      "us-east-2",
      "us-west-1", 
      "eu-west-1",
      "eu-west-2",
      "eu-central-1",
      "ap-southeast-1",
      "ap-southeast-2",
      "ap-northeast-1",
      "ap-south-1",
      "sa-east-1"
    ], var.region)
    error_message = "Invalid Supabase region. See https://supabase.com/docs/guides/platform/regions"
  }
}

variable "instance_size" {
  description = "Compute instance size. Free tier: 'micro' only. Pro tier: 'small', 'medium', 'large', 'xlarge', '2xlarge', '4xlarge'"
  type        = string
  default     = "micro"

  validation {
    condition = contains([
      "micro",    # Free tier (shared CPU, 1GB RAM)
      "small",    # Pro tier ($25/mo compute)
      "medium",   # Pro tier
      "large",    # Pro tier
      "xlarge",   # Pro tier
      "2xlarge",  # Pro tier
      "4xlarge"   # Pro tier
    ], var.instance_size)
    error_message = "Invalid instance size. Use 'micro' for free tier, or 'small'/'medium'/'large'/'xlarge'/'2xlarge'/'4xlarge' for Pro tier."
  }
}
