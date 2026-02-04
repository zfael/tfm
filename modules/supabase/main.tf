# Supabase Project Module
#
# Creates a Supabase project for PostgreSQL database.
#
# Usage:
#   module "supabase" {
#     source = "github.com/zfael/tfm//modules/supabase"
#
#     organization_id   = "org-xxx"
#     project_name      = "my-project"
#     database_password = var.db_password
#     region            = "us-east-1"
#     instance_size     = "micro"  # or "small", "medium", "large", etc.
#   }

resource "supabase_project" "main" {
  organization_id   = var.organization_id
  name              = var.project_name
  database_password = var.database_password
  region            = var.region

  # Instance size - only set for Pro tier (free tier can't specify)
  # null = free tier, "small"/"medium"/etc = Pro tier
  instance_size = var.instance_size

  lifecycle {
    ignore_changes = [database_password]
  }
}
