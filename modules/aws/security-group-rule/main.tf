# Security Group Rule Module
#
# Creates a single security group rule.
#
# Usage:
#   module "https_ingress" {
#     source = "github.com/zfael/tfm//modules/aws/security-group-rule"
#     
#     type              = "ingress"
#     security_group_id = module.sg.id
#     from_port         = 443
#     to_port           = 443
#     protocol          = "tcp"
#     cidr_blocks       = ["0.0.0.0/0"]
#   }

resource "aws_security_group_rule" "this" {
  type                     = var.type
  security_group_id        = var.security_group_id
  from_port                = var.from_port
  to_port                  = var.to_port
  protocol                 = var.protocol
  cidr_blocks              = var.cidr_blocks
  ipv6_cidr_blocks         = var.ipv6_cidr_blocks
  source_security_group_id = var.source_security_group_id
  description              = var.description
}
