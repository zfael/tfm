# AWS Accounts Module

Creates member accounts in AWS Organizations.

## Usage

```hcl
module "accounts" {
  source = "github.com/zfael/tfm//modules/aws/accounts"

  accounts = [
    {
      name                 = "dev"
      email                = "myorg+aws-dev@gmail.com"
      parent_id            = "ou-xxxx-xxxxxxxx"
      allow_billing_access = true
      tags                 = { Environment = "dev" }
    },
    {
      name      = "prod"
      email     = "myorg+aws-prod@gmail.com"
      parent_id = "ou-xxxx-xxxxxxxx"
      tags      = { Environment = "prod" }
    }
  ]

  tags = { ManagedBy = "terraform" }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `accounts` | List of accounts to create | `list(object)` | No |
| `tags` | Tags for all accounts | `map(string)` | No |

### accounts object

| Field | Description | Type | Required |
|-------|-------------|------|----------|
| `name` | Account name | `string` | Yes |
| `email` | Account root email | `string` | Yes |
| `parent_id` | OU ID for placement | `string` | Yes |
| `allow_billing_access` | Allow IAM billing access | `bool` | No (default: true) |
| `tags` | Additional tags | `map(string)` | No |

## Outputs

| Name | Description |
|------|-------------|
| `account_ids` | Map of account name → ID |
| `account_arns` | Map of account name → ARN |
| `account_emails` | Map of account name → email |
| `accounts` | Full account details |
