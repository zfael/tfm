# AWS Identity Center Module

Manages SSO users, permission sets, and account assignments.

## Usage

```hcl
module "identity_center" {
  source = "github.com/zfael/tfm//modules/aws/identity-center"

  permission_sets = [
    {
      name                = "AdminAccess"
      description         = "Full admin access"
      session_duration    = "PT2H"
      managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    },
    {
      name             = "DeveloperAccess"
      session_duration = "PT4H"
      inline_policy    = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect   = "Allow"
          Action   = ["ec2:*", "s3:*", "lambda:*"]
          Resource = "*"
        }]
      })
    }
  ]

  users = [
    {
      username     = "admin"
      email        = "admin@mycompany.com"
      given_name   = "Admin"
      family_name  = "User"
      display_name = "Admin User"
      assignments = [
        { permission_set = "AdminAccess", account_id = "123456789012" }
      ]
    }
  ]

  tags = { ManagedBy = "terraform" }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `users` | List of users to create | `list(object)` | No |
| `permission_sets` | List of permission sets | `list(object)` | No |
| `tags` | Tags for resources | `map(string)` | No |

### users object

| Field | Description | Type | Required |
|-------|-------------|------|----------|
| `username` | Username | `string` | Yes |
| `email` | Email address | `string` | Yes |
| `given_name` | First name | `string` | Yes |
| `family_name` | Last name | `string` | Yes |
| `display_name` | Display name | `string` | Yes |
| `assignments` | Account assignments | `list(object)` | No |

### permission_sets object

| Field | Description | Type | Required |
|-------|-------------|------|----------|
| `name` | Permission set name | `string` | Yes |
| `description` | Description | `string` | No |
| `session_duration` | Session duration (ISO 8601) | `string` | No (default: PT4H) |
| `inline_policy` | JSON inline policy | `string` | No |
| `managed_policy_arns` | AWS managed policy ARNs | `list(string)` | No |

## Outputs

| Name | Description |
|------|-------------|
| `instance_arn` | Identity Center instance ARN |
| `identity_store_id` | Identity Store ID |
| `user_ids` | Map of username → user ID |
| `users` | Full user details |
| `permission_set_arns` | Map of permission set name → ARN |
| `permission_sets` | Full permission set details |
