# Mock AWS provider for testing
mock_provider "aws" {}

# Test: Default values work
run "defaults" {
  command = plan

  assert {
    condition     = length(var.accounts) == 0
    error_message = "Default accounts should be empty"
  }

  assert {
    condition     = length(var.tags) == 0
    error_message = "Default tags should be empty"
  }
}

# Test: Accounts are created correctly
run "create_accounts" {
  command = plan

  variables {
    accounts = [
      {
        name      = "dev"
        email     = "test+dev@example.com"
        parent_id = "ou-xxxx-xxxxxxxx"
      },
      {
        name      = "prod"
        email     = "test+prod@example.com"
        parent_id = "ou-xxxx-xxxxxxxx"
      }
    ]
    tags = { Environment = "test" }
  }

  assert {
    condition     = length(aws_organizations_account.this) == 2
    error_message = "Should create 2 accounts"
  }
}

# Test: Billing access defaults to true
run "billing_access_default" {
  command = plan

  variables {
    accounts = [
      {
        name      = "dev"
        email     = "test+dev@example.com"
        parent_id = "ou-xxxx-xxxxxxxx"
      }
    ]
  }

  assert {
    condition     = aws_organizations_account.this["dev"].iam_user_access_to_billing == "ALLOW"
    error_message = "Billing access should default to ALLOW"
  }
}

# Test: Billing access can be denied
run "billing_access_denied" {
  command = plan

  variables {
    accounts = [
      {
        name                 = "restricted"
        email                = "test+restricted@example.com"
        parent_id            = "ou-xxxx-xxxxxxxx"
        allow_billing_access = false
      }
    ]
  }

  assert {
    condition     = aws_organizations_account.this["restricted"].iam_user_access_to_billing == "DENY"
    error_message = "Billing access should be DENY when disabled"
  }
}
