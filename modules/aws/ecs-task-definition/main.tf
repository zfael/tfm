# ECS Task Definition Module
#
# Creates an ECS task definition for Fargate.

resource "aws_ecs_task_definition" "this" {
  family                   = var.family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name      = var.container_name
    image     = var.container_image
    essential = true

    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }]

    environment = [for k, v in var.environment : { name = k, value = v }]
    secrets     = [for k, v in var.secrets : { name = k, valueFrom = v }]

    logConfiguration = var.log_group_name != null ? {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = var.log_group_name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = var.container_name
      }
    } : null

    healthCheck = var.health_check != null ? {
      command     = var.health_check.command
      interval    = var.health_check.interval
      timeout     = var.health_check.timeout
      retries     = var.health_check.retries
      startPeriod = var.health_check.start_period
    } : null
  }])

  tags = var.tags
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "this" {
  count             = var.create_log_group ? 1 : 0
  name              = var.log_group_name != null ? var.log_group_name : "/ecs/${var.family}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}
