# AWS Organization Module

Creates Organizational Units (OUs) and optional Service Control Policies (SCPs).

## Usage

```hcl
module "organization" {
  source = "github.com/zfael/tfm//modules/aws-organization"

  organizational_units = [
    { name = "Workloads" },
    { name = "Security" },
    { name = "Sandbox" }
  ]

  service_control_policies = [
    {
      name        = "DenyLeaveOrg"
      description = "Prevent leaving organization"
      content     = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect   = "Deny"
          Action   = "organizations:LeaveOrganization"
          Resource = "*"
        }]
      })
      targets = []  # Add OU IDs after first apply
    }
  ]

  tags = { ManagedBy = "terraform" }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `organizational_units` | List of OUs to create | `list(object)` | No |
| `service_control_policies` | List of SCPs to create | `list(object)` | No |
| `tags` | Tags for all resources | `map(string)` | No |

### organizational_units object

| Field | Description | Type | Required |
|-------|-------------|------|----------|
| `name` | OU name | `string` | Yes |
| `parent_id` | Parent OU ID (defaults to root) | `string` | No |
| `tags` | Additional tags | `map(string)` | No |

### service_control_policies object

| Field | Description | Type | Required |
|-------|-------------|------|----------|
| `name` | SCP name | `string` | Yes |
| `description` | SCP description | `string` | No |
| `content` | JSON policy document | `string` | Yes |
| `targets` | OU/account IDs to attach | `list(string)` | No |

## Outputs

| Name | Description |
|------|-------------|
| `root_id` | Organization root ID |
| `organization_id` | Organization ID |
| `master_account_id` | Management account ID |
| `ou_ids` | Map of OU name → ID |
| `ou_arns` | Map of OU name → ARN |
| `scp_ids` | Map of SCP name → ID |
