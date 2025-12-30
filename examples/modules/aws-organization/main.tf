# Example: Using individual modules
# Shows how to use aws-organization module standalone

module "organization" {
  source = "../../../modules/aws-organization"

  organizational_units = [
    { name = "Workloads" },
    { name = "Security" }
  ]

  # Optional: Add SCPs
  service_control_policies = [
    {
      name        = "DenyLeaveOrg"
      description = "Prevent accounts from leaving the organization"
      content = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Sid      = "DenyLeaveOrg"
            Effect   = "Deny"
            Action   = "organizations:LeaveOrganization"
            Resource = "*"
          }
        ]
      })
      # targets = [module.organization.ou_ids["Workloads"]]  # Attach after first apply
    }
  ]

  tags = {
    ManagedBy = "terraform"
  }
}

output "ou_ids" {
  value = module.organization.ou_ids
}
