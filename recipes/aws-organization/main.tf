# AWS Organization Recipe
# Batteries-included setup wiring org + accounts + identity-center

module "organization" {
  source = "../../modules/aws-organization"

  organizational_units     = var.organizational_units
  service_control_policies = var.service_control_policies
  tags                     = var.tags
}

module "accounts" {
  source = "../../modules/aws-accounts"

  accounts = [
    for account in var.accounts : {
      name                 = account.name
      email                = account.email
      parent_id            = lookup(module.organization.ou_ids, account.ou_name, module.organization.root_id)
      allow_billing_access = lookup(account, "allow_billing_access", true)
      tags                 = lookup(account, "tags", {})
    }
  ]

  tags = var.tags

  depends_on = [module.organization]
}

module "identity_center" {
  source = "../../modules/aws-identity-center"

  users = [
    for user in var.users : {
      username     = user.username
      email        = user.email
      given_name   = user.given_name
      family_name  = user.family_name
      display_name = user.display_name
      assignments = [
        for assignment in lookup(user, "assignments", []) : {
          permission_set = assignment.permission_set
          account_id     = lookup(module.accounts.account_ids, assignment.account_name, assignment.account_name)
        }
      ]
    }
  ]

  permission_sets = var.permission_sets
  tags            = var.tags

  depends_on = [module.accounts]
}
