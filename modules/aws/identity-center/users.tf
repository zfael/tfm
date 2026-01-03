# Identity Center Users

resource "aws_identitystore_user" "this" {
  for_each = { for user in var.users : user.username => user }

  identity_store_id = local.identity_store_id

  display_name = each.value.display_name
  user_name    = each.value.username

  name {
    given_name  = each.value.given_name
    family_name = each.value.family_name
  }

  emails {
    value   = each.value.email
    primary = true
  }
}
