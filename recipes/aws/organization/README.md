# AWS Organization Recipe

Batteries-included setup that wires together organization, accounts, and Identity Center.

## Usage

```hcl
module "my_org" {
  source = "github.com/zfael/tfm//recipes/aws/organization"

  # Organizational Units
  organizational_units = [
    { name = "Workloads" },
    { name = "Security" }
  ]

  # Member Accounts (references OU by name)
  accounts = [
    {
      name    = "dev"
      email   = "myorg+aws-dev@gmail.com"
      ou_name = "Workloads"
      tags    = { Environment = "dev" }
    },
    {
      name    = "prod"
      email   = "myorg+aws-prod@gmail.com"
      ou_name = "Workloads"
      tags    = { Environment = "prod" }
    }
  ]

  # Permission Sets
  permission_sets = [
    {
      name                = "AdminAccess"
      session_duration    = "PT2H"
      managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    },
    {
      name                = "ReadOnlyAccess"
      session_duration    = "PT8H"
      managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
    }
  ]

  # Users (references accounts by name, not ID)
  users = [
    {
      username     = "admin"
      email        = "admin@mycompany.com"
      given_name   = "Admin"
      family_name  = "User"
      display_name = "Admin User"
      assignments = [
        { permission_set = "AdminAccess", account_name = "dev" },
        { permission_set = "AdminAccess", account_name = "prod" }
      ]
    }
  ]

  tags = { ManagedBy = "terraform" }
}
```

## Key Features

- **Account references by name**: Use `account_name` instead of account IDs
- **OU references by name**: Use `ou_name` instead of OU IDs
- **Automatic wiring**: Modules are connected with proper dependencies

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `organizational_units` | List of OUs | `list(object)` | No |
| `service_control_policies` | List of SCPs | `list(object)` | No |
| `accounts` | List of accounts | `list(object)` | No |
| `users` | List of Identity Center users | `list(object)` | No |
| `permission_sets` | List of permission sets | `list(object)` | No |
| `tags` | Tags for all resources | `map(string)` | No |

## Outputs

| Name | Description |
|------|-------------|
| `organization_id` | AWS Organization ID |
| `root_id` | Organization root ID |
| `ou_ids` | Map of OU name → ID |
| `account_ids` | Map of account name → ID |
| `account_emails` | Map of account name → email |
| `user_ids` | Map of username → user ID |
| `permission_set_arns` | Map of permission set name → ARN |
