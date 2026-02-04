# SSM Parameter Module
#
# Creates a single SSM parameter.
#
# Usage:
#   module "db_url" {
#     source = "github.com/zfael/tfm//modules/aws/ssm"
#     name   = "/my-app/db/url"
#     value  = "postgresql://..."
#     secure = true
#   }

resource "aws_ssm_parameter" "this" {
  name   = var.name
  type   = var.secure ? "SecureString" : "String"
  value  = var.value
  key_id = var.secure && var.kms_key_id != null ? var.kms_key_id : null
  tags   = var.tags
}
