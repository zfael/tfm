# Organizational Units

resource "aws_organizations_organizational_unit" "this" {
  for_each = { for ou in var.organizational_units : ou.name => ou }

  name      = each.value.name
  parent_id = each.value.parent_id != null ? each.value.parent_id : local.root_id

  tags = merge(
    var.tags,
    {
      Name = each.value.name
    },
    lookup(each.value, "tags", {})
  )
}
