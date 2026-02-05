# Security Group with Rules Recipe
#
# Creates a security group with ingress/egress rules.
#
# Usage:
#   module "alb_sg" {
#     source = "github.com/zfael/tfm//recipes/aws/security-group-with-rules"
#     
#     name        = "my-alb-sg"
#     description = "ALB security group"
#     vpc_id      = data.aws_vpc.default.id
#     
#     ingress_rules = [
#       { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
#       { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
#     ]
#     egress_rules = [
#       { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
#     ]
#   }

module "sg" {
  source = "../../../modules/aws/security-group"

  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = var.tags
}

module "ingress_rules" {
  source   = "../../../modules/aws/security-group-rule"
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  type                     = "ingress"
  security_group_id        = module.sg.id
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  description              = lookup(each.value, "description", null)
}

module "egress_rules" {
  source   = "../../../modules/aws/security-group-rule"
  for_each = { for idx, rule in var.egress_rules : idx => rule }

  type                     = "egress"
  security_group_id        = module.sg.id
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  description              = lookup(each.value, "description", null)
}
