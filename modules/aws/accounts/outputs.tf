output "account_ids" {
  description = "Map of account name to account ID"
  value       = { for k, v in aws_organizations_account.this : k => v.id }
}

output "account_arns" {
  description = "Map of account name to account ARN"
  value       = { for k, v in aws_organizations_account.this : k => v.arn }
}

output "account_emails" {
  description = "Map of account name to account email"
  value       = { for k, v in aws_organizations_account.this : k => v.email }
}

output "accounts" {
  description = "Full account details"
  value = {
    for k, v in aws_organizations_account.this : k => {
      id    = v.id
      arn   = v.arn
      email = v.email
      name  = v.name
    }
  }
}
