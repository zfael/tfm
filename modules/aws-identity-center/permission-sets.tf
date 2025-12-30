# Permission Sets

resource "aws_ssoadmin_permission_set" "this" {
  for_each = { for ps in var.permission_sets : ps.name => ps }

  name             = each.value.name
  description      = lookup(each.value, "description", "Managed by Terraform")
  instance_arn     = local.instance_arn
  session_duration = lookup(each.value, "session_duration", "PT4H")

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}

# Inline policies for permission sets
resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each = {
    for ps in var.permission_sets : ps.name => ps
    if lookup(ps, "inline_policy", null) != null
  }

  inline_policy      = each.value.inline_policy
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
}

# AWS managed policy attachments
resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = {
    for item in flatten([
      for ps in var.permission_sets : [
        for policy_arn in lookup(ps, "managed_policy_arns", []) : {
          key                 = "${ps.name}-${policy_arn}"
          permission_set_name = ps.name
          managed_policy_arn  = policy_arn
        }
      ]
    ]) : item.key => item
  }

  instance_arn       = local.instance_arn
  managed_policy_arn = each.value.managed_policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set_name].arn
}
