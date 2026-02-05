# TFM - Terraform Modules Migration Plan

## Overview

Extract reusable Terraform modules from `vet-vault-provisioning/terraform` into generic, project-agnostic modules.

---

## Prerequisites: AWS Account Setup

Before using these modules, manual AWS setup is required:

### 1. Create Management Account
- Sign up at aws.amazon.com with root email (e.g., `myorg+aws-root@gmail.com`)
- Enable MFA on root user
- Create IAM user or use IAM Identity Center for admin access

### 2. Enable AWS Organizations
```bash
aws organizations create-organization --feature-set ALL
```

### 3. Enable Identity Center (SSO)
- AWS Console → IAM Identity Center → Enable
- Choose your preferred region (cannot change later)
- Note: This is a one-time manual step

### 4. Create Terraform State Backend
```bash
# Create S3 bucket for state
aws s3 mb s3://<org-name>-terraform-state-<account-id> --region <region>
aws s3api put-bucket-versioning --bucket <org-name>-terraform-state-<account-id> --versioning-configuration Status=Enabled

# Create DynamoDB table for locking
aws dynamodb create-table \
  --table-name <org-name>-terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

### 5. Configure Terraform Provider
```hcl
# In your root module (not in tfm modules)
terraform {
  backend "s3" {
    bucket         = "<org-name>-terraform-state-<account-id>"
    key            = "organization/terraform.tfstate"
    region         = "<region>"
    dynamodb_table = "<org-name>-terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "<region>"
}
```

### 6. Now Use TFM Modules
Once the above is done, you can use the modules to manage OUs, accounts, and Identity Center.

---

## Source Analysis

### Current Structure (vet-vault-provisioning/terraform)
```
├── organization/          # Org-level: accounts, OUs, Identity Center
├── accounts/dev/          # Per-account infra, calls modules
└── modules/
    └── app-infrastructure/ # Cognito (out of scope)
```

### What Needs Generalization

| Component | Current State | Generalization Needed |
|-----------|--------------|----------------------|
| Organization | Hardcoded emails, project name | Parameterize all project-specific values |
| Accounts | Hardcoded `dev` account | Support N accounts via variable |
| OUs | Single "Workloads" OU | Support custom OU structure |
| Identity Center | Hardcoded permission sets, role paths | Make permission sets configurable |

---

## Proposed TFM Structure

```
tfm/
├── modules/                       # Primitives (building blocks)
│   ├── aws-organization/          # AWS Org + OUs + SCPs
│   ├── aws-accounts/              # Member accounts
│   └── aws-identity-center/       # SSO users, permission sets, assignments
├── recipes/                       # Compositions (batteries-included)
│   └── aws-organization/          # Wires org + accounts + identity-center
├── examples/
│   ├── modules/                   # Per-module usage examples
│   └── recipes/                   # Recipe usage examples
└── README.md
```

---

## Module Specifications

### 1. `aws-organization`
**Purpose:** Create/manage OUs under org root, optional SCPs

**Inputs:**
- `organizational_units` - list of OU names/hierarchy
- `service_control_policies` - (optional) list of {name, description, content, targets}
- `tags`

**Outputs:**
- `ou_ids` - map of OU name → ID
- `root_id`
- `scp_ids` - map of SCP name → ID

**Internal structure:**
```
aws-organization/
├── main.tf
├── ous.tf              # Organizational units
├── scps.tf             # Service Control Policies (optional)
├── variables.tf
└── outputs.tf
```

---

### 2. `aws-accounts`
**Purpose:** Create member accounts in OUs

**Inputs:**
- `accounts` - list of {name, email, ou_name, tags}
- `ou_ids` - from aws-organization module
- `allow_billing_access`

**Outputs:**
- `account_ids` - map of name → ID
- `account_emails`

---

### 3. `aws-identity-center`
**Purpose:** Manage SSO users, permission sets, account assignments

**Inputs:**
- `users` - list of {username, email, names, permission_sets}
- `permission_sets` - list of {name, description, duration, policies}
- `account_ids` - map for assignments

**Outputs:**
- `user_ids`
- `permission_set_arns`

**Internal structure:** Separate files for users vs permissions (easy to split later if needed):
```
aws-identity-center/
├── main.tf
├── users.tf           # User/group creation
├── permission-sets.tf # Permission set definitions
├── assignments.tf     # Account assignments
├── variables.tf
└── outputs.tf
```

---

## Recipe Specifications

### `recipes/aws-organization`
**Purpose:** Batteries-included org setup — wires together all org modules

**Internally calls:**
- `modules/aws-organization` (OUs + SCPs)
- `modules/aws-accounts` (member accounts)
- `modules/aws-identity-center` (users + permissions)

**Inputs:**
- `organizational_units`
- `service_control_policies` (optional)
- `accounts`
- `identity_center_users`
- `permission_sets`
- `tags`

**Outputs:**
- All outputs from child modules exposed

---

## Migration Tasks

- [ ] Create module structure in tfm/
- [ ] Migrate modules/aws-organization
- [ ] Migrate modules/aws-accounts
- [ ] Migrate modules/aws-identity-center
- [ ] Create recipes/aws-organization (composition)
- [ ] Create examples for modules
- [ ] Create examples for recipes
- [ ] Create root README with usage docs
- [ ] Add module/recipe READMEs with input/output docs

---

## Key Design Decisions

1. **No hardcoded project names** - all via variables
2. **No hardcoded emails** - passed as inputs
3. **No hardcoded IAM policies** - configurable or use AWS managed
4. **Flexible permission sets** - inline policies via variable, not hardcoded
5. **Backend configs** - NOT in modules (consumer responsibility)
6. **Examples in README** - no separate tfvars files
7. **Versioning via git tags** - publish strategy TBD

---

## Unresolved Questions

1. Where to publish modules? (GitHub source, Terraform Registry, S3, etc.) — decide later
