# Example: Using the aws-organization recipe
# This shows a complete org setup with OUs, accounts, and Identity Center

module "my_org" {
  source = "../../../recipes/aws-organization"

  # Organizational Units
  organizational_units = [
    { name = "Workloads" },
    { name = "Security" },
    { name = "Sandbox" }
  ]

  # Member Accounts
  accounts = [
    {
      name     = "dev"
      email    = "myorg+aws-dev@gmail.com"
      ou_name  = "Workloads"
      tags     = { Environment = "dev" }
    },
    {
      name     = "prod"
      email    = "myorg+aws-prod@gmail.com"
      ou_name  = "Workloads"
      tags     = { Environment = "prod" }
    },
    {
      name     = "security"
      email    = "myorg+aws-security@gmail.com"
      ou_name  = "Security"
      tags     = { Environment = "security" }
    }
  ]

  # Permission Sets
  permission_sets = [
    {
      name             = "AdminAccess"
      description      = "Full admin access"
      session_duration = "PT2H"
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/AdministratorAccess"
      ]
    },
    {
      name             = "DeveloperAccess"
      description      = "Developer access for dev work"
      session_duration = "PT4H"
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/PowerUserAccess"
      ]
    },
    {
      name             = "ReadOnlyAccess"
      description      = "Read-only access"
      session_duration = "PT8H"
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
      ]
    }
  ]

  # Identity Center Users
  users = [
    {
      username     = "admin"
      email        = "admin@mycompany.com"
      given_name   = "Admin"
      family_name  = "User"
      display_name = "Admin User"
      assignments = [
        { permission_set = "AdminAccess", account_name = "dev" },
        { permission_set = "AdminAccess", account_name = "prod" },
        { permission_set = "AdminAccess", account_name = "security" }
      ]
    },
    {
      username     = "developer"
      email        = "dev@mycompany.com"
      given_name   = "Dev"
      family_name  = "User"
      display_name = "Dev User"
      assignments = [
        { permission_set = "DeveloperAccess", account_name = "dev" },
        { permission_set = "ReadOnlyAccess", account_name = "prod" }
      ]
    }
  ]

  tags = {
    Project   = "my-project"
    ManagedBy = "terraform"
  }
}

output "account_ids" {
  value = module.my_org.account_ids
}

output "permission_set_arns" {
  value = module.my_org.permission_set_arns
}
