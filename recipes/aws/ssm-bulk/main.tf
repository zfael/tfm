# SSM Bulk Parameters Recipe
#
# Creates multiple SSM parameters with a common prefix.
#
# Usage:
#   module "ssm" {
#     source = "github.com/zfael/tfm//recipes/aws/ssm-bulk"
#
#     prefix = "my-app"
#     parameters = {
#       "db/url"      = { value = "postgresql://...", secure = true }
#       "db/password" = { value = "secret", secure = true }
#       "config/key"  = { value = "value" }
#     }
#   }
#
# Creates: /my-app/db/url, /my-app/db/password, /my-app/config/key

module "params" {
  source   = "../../modules/aws/ssm"
  for_each = var.parameters

  name       = "/${var.prefix}/${each.key}"
  value      = each.value.value
  secure     = lookup(each.value, "secure", false)
  kms_key_id = var.kms_key_id
  tags       = var.tags
}
