# Mock AWS provider for testing
mock_provider "aws" {}

# Override data sources with mock values
override_data {
  target = data.aws_organizations_organization.this
  values = {
    id                = "o-mock123456"
    master_account_id = "123456789012"
    roots = [{
      id   = "r-mock"
      arn  = "arn:aws:organizations::123456789012:root/o-mock123456/r-mock"
      name = "Root"
    }]
  }
}

# Test: Default values work
run "defaults" {
  command = plan

  assert {
    condition     = length(var.organizational_units) == 0
    error_message = "Default organizational_units should be empty"
  }

  assert {
    condition     = length(var.service_control_policies) == 0
    error_message = "Default SCPs should be empty"
  }

  assert {
    condition     = length(var.tags) == 0
    error_message = "Default tags should be empty"
  }
}

# Test: OUs are created correctly
run "create_ous" {
  command = plan

  variables {
    organizational_units = [
      { name = "Workloads" },
      { name = "Security" }
    ]
    tags = { Environment = "test" }
  }

  assert {
    condition     = length(aws_organizations_organizational_unit.this) == 2
    error_message = "Should create 2 OUs"
  }
}

# Test: SCPs are created correctly
run "create_scps" {
  command = plan

  variables {
    service_control_policies = [
      {
        name        = "DenyLeaveOrg"
        description = "Test SCP"
        content = jsonencode({
          Version = "2012-10-17"
          Statement = [{
            Effect   = "Deny"
            Action   = "organizations:LeaveOrganization"
            Resource = "*"
          }]
        })
      }
    ]
  }

  assert {
    condition     = length(aws_organizations_policy.this) == 1
    error_message = "Should create 1 SCP"
  }
}
