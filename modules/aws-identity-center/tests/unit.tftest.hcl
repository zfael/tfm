# Mock AWS provider for testing
mock_provider "aws" {}

# Override data sources with mock values
override_data {
  target = data.aws_ssoadmin_instances.this
  values = {
    arns               = ["arn:aws:sso:::instance/ssoins-mock123456"]
    identity_store_ids = ["d-mock123456"]
  }
}

# Test: Default values work
run "defaults" {
  command = plan

  assert {
    condition     = length(var.users) == 0
    error_message = "Default users should be empty"
  }

  assert {
    condition     = length(var.permission_sets) == 0
    error_message = "Default permission_sets should be empty"
  }
}

# Test: Users are created correctly
run "create_users" {
  command = plan

  variables {
    users = [
      {
        username     = "testuser"
        email        = "test@example.com"
        given_name   = "Test"
        family_name  = "User"
        display_name = "Test User"
      }
    ]
  }

  assert {
    condition     = length(aws_identitystore_user.this) == 1
    error_message = "Should create 1 user"
  }

  assert {
    condition     = aws_identitystore_user.this["testuser"].user_name == "testuser"
    error_message = "Username should match"
  }
}

# Test: Permission sets are created correctly
run "create_permission_sets" {
  command = plan

  variables {
    permission_sets = [
      {
        name             = "AdminAccess"
        description      = "Admin access"
        session_duration = "PT2H"
      },
      {
        name = "ReadOnly"
      }
    ]
  }

  assert {
    condition     = length(aws_ssoadmin_permission_set.this) == 2
    error_message = "Should create 2 permission sets"
  }

  assert {
    condition     = aws_ssoadmin_permission_set.this["AdminAccess"].session_duration == "PT2H"
    error_message = "Session duration should be PT2H"
  }

  assert {
    condition     = aws_ssoadmin_permission_set.this["ReadOnly"].session_duration == "PT4H"
    error_message = "Default session duration should be PT4H"
  }
}

# Test: Managed policies are attached
run "managed_policies" {
  command = plan

  variables {
    permission_sets = [
      {
        name = "AdminAccess"
        managed_policy_arns = [
          "arn:aws:iam::aws:policy/AdministratorAccess",
          "arn:aws:iam::aws:policy/ReadOnlyAccess"
        ]
      }
    ]
  }

  assert {
    condition     = length(aws_ssoadmin_managed_policy_attachment.this) == 2
    error_message = "Should attach 2 managed policies"
  }
}

# Test: Inline policy is attached
run "inline_policy" {
  command = plan

  variables {
    permission_sets = [
      {
        name = "CustomAccess"
        inline_policy = jsonencode({
          Version = "2012-10-17"
          Statement = [{
            Effect   = "Allow"
            Action   = "s3:*"
            Resource = "*"
          }]
        })
      }
    ]
  }

  assert {
    condition     = length(aws_ssoadmin_permission_set_inline_policy.this) == 1
    error_message = "Should create 1 inline policy"
  }
}
