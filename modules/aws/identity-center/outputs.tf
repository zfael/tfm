output "instance_arn" {
  description = "Identity Center instance ARN"
  value       = local.instance_arn
}

output "identity_store_id" {
  description = "Identity Store ID"
  value       = local.identity_store_id
}

output "user_ids" {
  description = "Map of username to user ID"
  value       = { for k, v in aws_identitystore_user.this : k => v.user_id }
}

output "users" {
  description = "Full user details"
  value = {
    for k, v in aws_identitystore_user.this : k => {
      user_id      = v.user_id
      display_name = v.display_name
      email        = v.emails[0].value
    }
  }
}

output "permission_set_arns" {
  description = "Map of permission set name to ARN"
  value       = { for k, v in aws_ssoadmin_permission_set.this : k => v.arn }
}

output "permission_sets" {
  description = "Full permission set details"
  value = {
    for k, v in aws_ssoadmin_permission_set.this : k => {
      arn              = v.arn
      name             = v.name
      session_duration = v.session_duration
    }
  }
}
