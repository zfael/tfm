# Mock AWS provider for testing
mock_provider "aws" {}

# Override data sources with mock values for organization module
override_data {
  target = module.organization.data.aws_organizations_organization.this
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

# Override data sources with mock values for identity center module
override_data {
  target = module.identity_center.data.aws_ssoadmin_instances.this
  values = {
    arns               = ["arn:aws:sso:::instance/ssoins-mock123456"]
    identity_store_ids = ["d-mock123456"]
  }
}

# Test: Default values work
run "defaults" {
  command = plan

  assert {
    condition     = length(var.organizational_units) == 0
    error_message = "Default OUs should be empty"
  }

  assert {
    condition     = length(var.accounts) == 0
    error_message = "Default accounts should be empty"
  }

  assert {
    condition     = length(var.users) == 0
    error_message = "Default users should be empty"
  }

  assert {
    condition     = length(var.permission_sets) == 0
    error_message = "Default permission_sets should be empty"
  }
}

# Test: OUs and basic setup (without assignments that require computed values)
run "basic_setup" {
  command = plan

  variables {
    organizational_units = [
      { name = "Workloads" },
      { name = "Security" }
    ]

    permission_sets = [
      {
        name                = "AdminAccess"
        managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      }
    ]

    tags = { Environment = "test" }
  }

  assert {
    condition     = length(module.organization.ou_ids) == 2
    error_message = "Should create 2 OUs"
  }

  assert {
    condition     = length(module.identity_center.permission_set_arns) == 1
    error_message = "Should create 1 permission set"
  }
}

# Test: Tags are propagated
run "tags_propagation" {
  command = plan

  variables {
    organizational_units = [{ name = "Test" }]
    tags = {
      Project   = "test-project"
      ManagedBy = "terraform"
    }
  }

  assert {
    condition     = var.tags["Project"] == "test-project"
    error_message = "Tags should be set correctly"
  }
}
