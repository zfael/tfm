# Service Control Policies (Optional)

resource "aws_organizations_policy" "this" {
  for_each = { for scp in var.service_control_policies : scp.name => scp }

  name        = each.value.name
  description = lookup(each.value, "description", "Managed by Terraform")
  type        = "SERVICE_CONTROL_POLICY"
  content     = each.value.content

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    }
  )
}

resource "aws_organizations_policy_attachment" "this" {
  for_each = {
    for item in flatten([
      for scp in var.service_control_policies : [
        for target in lookup(scp, "targets", []) : {
          key       = "${scp.name}-${target}"
          policy_id = aws_organizations_policy.this[scp.name].id
          target_id = target
        }
      ]
    ]) : item.key => item
  }

  policy_id = each.value.policy_id
  target_id = each.value.target_id
}
