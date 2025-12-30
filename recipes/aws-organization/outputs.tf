# Organization outputs
output "organization_id" {
  description = "AWS Organization ID"
  value       = module.organization.organization_id
}

output "root_id" {
  description = "Organization root ID"
  value       = module.organization.root_id
}

output "master_account_id" {
  description = "Management account ID"
  value       = module.organization.master_account_id
}

output "ou_ids" {
  description = "Map of OU name to OU ID"
  value       = module.organization.ou_ids
}

output "scp_ids" {
  description = "Map of SCP name to SCP ID"
  value       = module.organization.scp_ids
}

# Accounts outputs
output "account_ids" {
  description = "Map of account name to account ID"
  value       = module.accounts.account_ids
}

output "account_emails" {
  description = "Map of account name to account email"
  value       = module.accounts.account_emails
}

output "accounts" {
  description = "Full account details"
  value       = module.accounts.accounts
}

# Identity Center outputs
output "identity_center_instance_arn" {
  description = "Identity Center instance ARN"
  value       = module.identity_center.instance_arn
}

output "user_ids" {
  description = "Map of username to user ID"
  value       = module.identity_center.user_ids
}

output "users" {
  description = "Full user details"
  value       = module.identity_center.users
}

output "permission_set_arns" {
  description = "Map of permission set name to ARN"
  value       = module.identity_center.permission_set_arns
}

output "permission_sets" {
  description = "Full permission set details"
  value       = module.identity_center.permission_sets
}
