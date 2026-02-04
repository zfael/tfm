# Supabase Project Module

Creates a Supabase project with PostgreSQL database.

## Usage

```hcl
# Provider configuration (in your root module)
provider "supabase" {
  access_token = var.supabase_access_token
}

# Module usage
module "supabase" {
  source = "github.com/zfael/tfm//modules/supabase"

  organization_id   = "org-xxxxx"
  project_name      = "my-app-prod"
  database_password = var.database_password
  region            = "us-east-1"
  instance_size     = "micro"  # Free tier
}
```

## Requirements

1. **Supabase Access Token**: Generate at https://supabase.com/dashboard/account/tokens
2. **Organization ID**: Found in Supabase Dashboard > Settings > General

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `organization_id` | Supabase organization ID | `string` | - | Yes |
| `project_name` | Name for the project | `string` | - | Yes |
| `database_password` | PostgreSQL password | `string` | - | Yes |
| `region` | Supabase region | `string` | `us-east-1` | No |
| `instance_size` | Compute instance size | `string` | `micro` | No |

### Instance Sizes (Tiers)

| Size | Tier | CPU | RAM | Cost |
|------|------|-----|-----|------|
| `micro` | Free | Shared | 1 GB | $0/mo |
| `small` | Pro | 2 core | 4 GB | ~$25/mo |
| `medium` | Pro | 4 core | 8 GB | ~$50/mo |
| `large` | Pro | 8 core | 16 GB | ~$100/mo |
| `xlarge` | Pro | 16 core | 32 GB | ~$200/mo |
| `2xlarge` | Pro | 32 core | 64 GB | ~$400/mo |
| `4xlarge` | Pro | 64 core | 128 GB | ~$800/mo |

> **Note:** Pro tier instances require Pro organization billing enabled in Supabase dashboard.

### Available Regions

- `us-east-1` (N. Virginia)
- `us-west-1` (N. California)
- `eu-west-1` (Ireland)
- `eu-west-2` (London)
- `eu-central-1` (Frankfurt)
- `ap-southeast-1` (Singapore)
- `ap-southeast-2` (Sydney)
- `ap-northeast-1` (Tokyo)
- `ap-south-1` (Mumbai)
- `sa-east-1` (São Paulo)

## Outputs

| Name | Description |
|------|-------------|
| `project_id` | Supabase project ID (also called project ref) |
| `project_name` | Project name |
| `database_host` | Direct PostgreSQL host |
| `pooler_host` | Connection pooler host (recommended) |
| `database_url` | Connection string template |
| `api_url` | Supabase API URL |

> **Note:** API keys (`anon_key`, `service_role_key`) are not available via Terraform. Get them from the Supabase dashboard: Project Settings > API.

## Connection String

The `database_url` output provides a template. Replace `[PASSWORD]` with your actual password:

```
postgresql://postgres.{project_id}:{PASSWORD}@aws-0-{region}.pooler.supabase.com:6543/postgres
```

For direct connections (not pooled):
```
postgresql://postgres:{PASSWORD}@db.{project_id}.supabase.co:5432/postgres
```
