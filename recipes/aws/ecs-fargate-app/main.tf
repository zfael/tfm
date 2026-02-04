# ECS Fargate App Recipe
#
# Composes: ECR, ECS cluster, ALB, listeners, target group,
# task definition, IAM roles, and ECS service.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

# -----------------------------------------------------------------------------
# ECR Repository
# -----------------------------------------------------------------------------
module "ecr" {
  source = "../../../modules/aws/ecr"

  name                 = var.name
  image_tag_mutability = "MUTABLE"
  force_delete         = var.ecr_force_delete
  max_image_count      = var.ecr_lifecycle_count
  tags                 = var.tags
}

# -----------------------------------------------------------------------------
# ECS Cluster
# -----------------------------------------------------------------------------
module "ecs_cluster" {
  source = "../../../modules/aws/ecs-cluster"

  name               = var.cluster_name != null ? var.cluster_name : var.name
  container_insights = var.container_insights
  tags               = var.tags
}

# -----------------------------------------------------------------------------
# IAM Roles
# -----------------------------------------------------------------------------

# Task Execution Role (ECR pull, logs, SSM secrets)
resource "aws_iam_role" "execution" {
  name = "${var.name}-ecs-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "execution_ecr" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "execution_ssm" {
  count = length(var.secrets) > 0 ? 1 : 0
  name  = "ssm-access"
  role  = aws_iam_role.execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["ssm:GetParameters", "ssm:GetParameter"]
      Resource = [for k, v in var.secrets : v]
    }]
  })
}

# Task Role (app permissions)
resource "aws_iam_role" "task" {
  name = "${var.name}-ecs-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "task_s3" {
  count = var.s3_bucket_arn != null ? 1 : 0
  name  = "s3-access"
  role  = aws_iam_role.task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ]
      Resource = [
        var.s3_bucket_arn,
        "${var.s3_bucket_arn}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy" "task_ssm" {
  count = length(var.task_ssm_parameters) > 0 ? 1 : 0
  name  = "ssm-read"
  role  = aws_iam_role.task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["ssm:GetParameters", "ssm:GetParameter", "ssm:GetParametersByPath"]
      Resource = var.task_ssm_parameters
    }]
  })
}

# -----------------------------------------------------------------------------
# ALB
# -----------------------------------------------------------------------------
module "alb" {
  source = "../../../modules/aws/alb"

  name               = var.name
  internal           = false
  security_group_ids = var.alb_security_group_ids
  subnet_ids         = var.public_subnet_ids
  tags               = var.tags
}

# Target Group
module "target_group" {
  source = "../../../modules/aws/alb-target-group"

  name        = var.name
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check = {
    path    = var.health_check_path
    matcher = var.health_check_matcher
  }
  tags = var.tags
}

# HTTPS Listener
module "https_listener" {
  source = "../../../modules/aws/alb-listener"

  load_balancer_arn   = module.alb.arn
  port                = 443
  protocol            = "HTTPS"
  certificate_arn     = var.certificate_arn
  default_action_type = "forward"
  target_group_arn    = module.target_group.arn
  tags                = var.tags
}

# HTTP → HTTPS Redirect
module "http_listener" {
  source = "../../../modules/aws/alb-listener"

  load_balancer_arn    = module.alb.arn
  port                 = 80
  protocol             = "HTTP"
  default_action_type  = "redirect"
  redirect_port        = "443"
  redirect_protocol    = "HTTPS"
  redirect_status_code = "HTTP_301"
  tags                 = var.tags
}

# -----------------------------------------------------------------------------
# Task Definition
# -----------------------------------------------------------------------------
module "task_definition" {
  source = "../../../modules/aws/ecs-task-definition"

  family             = var.name
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn      = aws_iam_role.task.arn
  container_name     = var.name
  container_image    = "${module.ecr.repository_url}:${var.image_tag}"
  container_port     = var.container_port
  environment        = var.environment
  secrets            = var.secrets
  aws_region         = local.region
  log_group_name     = "/ecs/${var.name}"
  log_retention_days = var.log_retention_days
  health_check       = var.container_health_check
  tags               = var.tags
}

# -----------------------------------------------------------------------------
# ECS Service
# -----------------------------------------------------------------------------
module "ecs_service" {
  source = "../../../modules/aws/ecs-service"

  name                = var.name
  cluster_arn         = module.ecs_cluster.arn
  task_definition_arn = module.task_definition.arn
  desired_count       = var.desired_count
  subnet_ids          = var.public_subnet_ids
  security_group_ids  = var.ecs_security_group_ids
  assign_public_ip    = true
  target_group_arn    = module.target_group.arn
  container_name      = var.name
  container_port      = var.container_port
  tags                = var.tags
}
