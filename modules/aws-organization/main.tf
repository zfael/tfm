# AWS Organization Module
# Manages Organizational Units and Service Control Policies

data "aws_organizations_organization" "this" {}

locals {
  root_id = data.aws_organizations_organization.this.roots[0].id
}
