output "project_id" {
  description = "The ID of the Supabase project"
  value       = supabase_project.main.id
}

output "project_name" {
  description = "The name of the Supabase project"
  value       = supabase_project.main.name
}

output "database_host" {
  description = "PostgreSQL direct database host"
  value       = "db.${supabase_project.main.id}.supabase.co"
}

output "pooler_host" {
  description = "PostgreSQL connection pooler host (recommended for serverless)"
  value       = "aws-0-${var.region}.pooler.supabase.com"
}

output "database_url" {
  description = "PostgreSQL connection string template (replace [PASSWORD])"
  value       = "postgresql://postgres.${supabase_project.main.id}:[PASSWORD]@aws-0-${var.region}.pooler.supabase.com:6543/postgres"
}

output "api_url" {
  description = "Supabase API URL"
  value       = "https://${supabase_project.main.id}.supabase.co"
}
