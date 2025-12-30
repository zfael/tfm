output "root_id" {
  description = "The ID of the organization root"
  value       = local.root_id
}

output "organization_id" {
  description = "The ID of the organization"
  value       = data.aws_organizations_organization.this.id
}

output "master_account_id" {
  description = "The ID of the management account"
  value       = data.aws_organizations_organization.this.master_account_id
}

output "ou_ids" {
  description = "Map of OU name to OU ID"
  value       = { for k, v in aws_organizations_organizational_unit.this : k => v.id }
}

output "ou_arns" {
  description = "Map of OU name to OU ARN"
  value       = { for k, v in aws_organizations_organizational_unit.this : k => v.arn }
}

output "scp_ids" {
  description = "Map of SCP name to SCP ID"
  value       = { for k, v in aws_organizations_policy.this : k => v.id }
}
