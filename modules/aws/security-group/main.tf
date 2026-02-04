# Security Group Module
#
# Creates a security group (dumb - just the SG, no rules).
#
# Usage:
#   module "my_sg" {
#     source = "github.com/zfael/tfm//modules/aws/security-group"
#     
#     name        = "my-sg"
#     description = "My security group"
#     vpc_id      = data.aws_vpc.default.id
#   }

resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = var.name })

  lifecycle {
    create_before_destroy = true
  }
}
