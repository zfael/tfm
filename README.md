# TFM - Terraform Modules

Reusable Terraform modules for AWS infrastructure.

## Structure

```
tfm/
├── modules/                       # Primitives (building blocks)
│   ├── aws-organization/          # AWS Org + OUs + SCPs
│   ├── aws-accounts/              # Member accounts
│   └── aws-identity-center/       # SSO users, permission sets, assignments
├── recipes/                       # Compositions (batteries-included)
│   └── aws-organization/          # Wires org + accounts + identity-center
└── examples/
    ├── modules/                   # Per-module usage examples
    └── recipes/                   # Recipe usage examples
```

## Quick Start

### Using the Recipe (recommended)

```hcl
module "my_org" {
  source = "github.com/zfael/tfm//recipes/aws-organization"

  organizational_units = [
    { name = "Workloads" },
    { name = "Security" }
  ]

  accounts = [
    {
      name    = "dev"
      email   = "myorg+aws-dev@gmail.com"
      ou_name = "Workloads"
    }
  ]

  permission_sets = [
    {
      name                = "AdminAccess"
      managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    }
  ]

  users = [
    {
      username     = "admin"
      email        = "admin@mycompany.com"
      given_name   = "Admin"
      family_name  = "User"
      display_name = "Admin User"
      assignments  = [
        { permission_set = "AdminAccess", account_name = "dev" }
      ]
    }
  ]

  tags = { ManagedBy = "terraform" }
}
```

### Using Individual Modules

```hcl
module "organization" {
  source = "github.com/zfael/tfm//modules/aws-organization"

  organizational_units = [
    { name = "Workloads" }
  ]
}

module "accounts" {
  source = "github.com/zfael/tfm//modules/aws-accounts"

  accounts = [
    {
      name      = "dev"
      email     = "myorg+aws-dev@gmail.com"
      parent_id = module.organization.ou_ids["Workloads"]
    }
  ]
}
```

## Prerequisites

Before using these modules, you need to set up AWS manually:

1. **Create Management Account** - Sign up at aws.amazon.com
2. **Enable AWS Organizations** - `aws organizations create-organization --feature-set ALL`
3. **Enable Identity Center** - AWS Console → IAM Identity Center → Enable
4. **Create Terraform State Backend** - S3 bucket + DynamoDB table

See [PLAN.md](./PLAN.md) for detailed setup instructions.

## Modules

| Module | Description |
|--------|-------------|
| `aws-organization` | Creates OUs and optional SCPs |
| `aws-accounts` | Creates member accounts in OUs |
| `aws-identity-center` | Manages SSO users, permission sets, and account assignments |

## Recipes

| Recipe | Description |
|--------|-------------|
| `aws-organization` | Complete org setup wiring all modules together |

## License

MIT