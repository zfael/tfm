# Account Assignments

locals {
  # Flatten user assignments into a list
  user_assignments = flatten([
    for user in var.users : [
      for assignment in lookup(user, "assignments", []) : {
        key             = "${user.username}-${assignment.permission_set}-${assignment.account_id}"
        username        = user.username
        permission_set  = assignment.permission_set
        account_id      = assignment.account_id
      }
    ]
  ])
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = { for a in local.user_assignments : a.key => a }

  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set].arn

  principal_id   = aws_identitystore_user.this[each.value.username].user_id
  principal_type = "USER"

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"

  depends_on = [
    aws_identitystore_user.this,
    aws_ssoadmin_permission_set.this
  ]
}
