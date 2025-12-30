# Member Accounts

resource "aws_organizations_account" "this" {
  for_each = { for account in var.accounts : account.name => account }

  name                       = each.value.name
  email                      = each.value.email
  parent_id                  = each.value.parent_id
  iam_user_access_to_billing = each.value.allow_billing_access ? "ALLOW" : "DENY"

  # Important: Don't manage the role name as it's created automatically
  lifecycle {
    ignore_changes = [role_name]
  }

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    },
    lookup(each.value, "tags", {})
  )
}
