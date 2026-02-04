# Domain + ACM Certificate Plan

## Overview

Setup custom domain with SSL certificate for CloudFront via AWS Route53 + ACM.

**Supports:** Same-account and cross-account setups.

---

## Prerequisites (Manual)

| Step | Action | How | Account |
|------|--------|-----|---------|
| 1 | Buy domain | AWS Console → Route53 → Register Domain | Management |
| 2 | Route53 zone | Auto-created by AWS on purchase | Management |
| 3 | IAM role for cross-account | Terraform (see below) | Management |

**Note:** Domain purchase cannot be automated (AWS limitation).

---

## Architecture

### Cross-Account Setup (Recommended)

```
Management Account
├── Route53 Domain (manual purchase)
├── Route53 Hosted Zone (auto-created)
└── IAM Role: Route53AccessRole (Terraform)

Dev Account
├── ACM Certificate for dev.example.com (Terraform)
└── CloudFront Distribution (Terraform)

Prod Account
├── ACM Certificate for example.com (Terraform)
└── CloudFront Distribution (Terraform)
```

### Same-Account Setup

```
Single Account
├── Route53 Domain + Hosted Zone
├── ACM Certificate (Terraform)
└── CloudFront Distribution (Terraform)
```

---

## Terraform Modules

### `modules/aws/acm-certificate` ✅ IMPLEMENTED

**Purpose:** Request ACM certificate + DNS validation via Route53

**Providers:**
- `aws` - for ACM certificate (must be us-east-1 for CloudFront)
- `aws.route53` - for DNS records (can be different account)

**Inputs:**
- `domain_name` - primary domain (e.g., `example.com`)
- `subject_alternative_names` - optional SANs (e.g., `["*.example.com"]`)
- `route53_zone_id` - for auto DNS validation
- `wait_for_validation` - wait for cert to be issued
- `tags`

**Outputs:**
- `certificate_arn` - for CloudFront
- `validated_certificate_arn` - use this for CloudFront
- `domain_validation_options` - for manual DNS (if not using Route53)

**Important:** Must deploy in `us-east-1` for CloudFront compatibility.

### `modules/aws/cloudfront-distribution` ✅ EXISTS

Already supports `acm_certificate_arn` input. No changes needed.

---

## Usage Examples

### Same Account

```hcl
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

data "aws_route53_zone" "main" {
  name = "example.com"
}

module "certificate" {
  source = "github.com/your-org/tfm//modules/aws/acm-certificate"
  
  providers = {
    aws         = aws.us_east_1
    aws.route53 = aws.us_east_1
  }

  domain_name               = "example.com"
  subject_alternative_names = ["*.example.com"]
  route53_zone_id           = data.aws_route53_zone.main.zone_id
}

module "cloudfront" {
  source = "github.com/your-org/tfm//modules/aws/cloudfront-distribution"

  aliases             = ["example.com", "www.example.com"]
  acm_certificate_arn = module.certificate.validated_certificate_arn
}
```

### Cross-Account (Dev/Prod)

```hcl
# Provider for ACM in current account (us-east-1 required)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Provider for Route53 in management account
provider "aws" {
  alias  = "route53_management"
  region = "us-east-1"
  
  assume_role {
    role_arn = "arn:aws:iam::MANAGEMENT_ACCOUNT_ID:role/Route53AccessRole"
  }
}

module "certificate" {
  source = "github.com/your-org/tfm//modules/aws/acm-certificate"
  
  providers = {
    aws         = aws.us_east_1
    aws.route53 = aws.route53_management
  }

  domain_name               = "dev.example.com"  # or prod: example.com
  subject_alternative_names = ["*.dev.example.com"]
  route53_zone_id           = "Z1234567890"  # management account zone

  tags = { Environment = "dev" }
}

module "cloudfront" {
  source = "github.com/your-org/tfm//modules/aws/cloudfront-distribution"

  aliases             = ["dev.example.com"]
  acm_certificate_arn = module.certificate.validated_certificate_arn
}
```

---

## Cross-Account IAM Role (Management Account)

Create in management account to allow dev/prod access to Route53:

```hcl
resource "aws_iam_role" "route53_access" {
  name = "Route53AccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = [
          "arn:aws:iam::DEV_ACCOUNT_ID:root",
          "arn:aws:iam::PROD_ACCOUNT_ID:root"
        ]
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "route53_access" {
  name = "Route53RecordManagement"
  role = aws_iam_role.route53_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "route53:GetHostedZone",
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ]
      Resource = "arn:aws:route53:::hostedzone/ZONE_ID"
    }]
  })
}
```

---

## Implementation Tasks

- [x] Create `modules/aws/acm-certificate` module
  - [x] main.tf - cert request + validation resources
  - [x] variables.tf
  - [x] outputs.tf
  - [x] versions.tf
  - [x] README.md
- [x] Add cross-account provider support
- [ ] Create Route53 cross-account IAM role module (optional)
- [ ] Test with real domain (after purchase)

---

## Cost

| Item | Cost |
|------|------|
| Domain (.com) | ~$13/yr |
| Route53 Hosted Zone | $0.50/mo |
| ACM Certificate | FREE |
| **Total** | ~$19/yr |

---

## Next Steps

1. **You:** Buy domain via Route53 (management account)
2. **You:** Create Route53AccessRole in management account
3. **Terraform:** Apply certificate module in dev/prod
4. **AWS:** Validates cert (2-30 min)
5. **Terraform:** Wire to CloudFront
