resource "aws_cloudwatch_log_group" "frontend_log_group" {
  name              = "/ecs/frontend-${var.name}"
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend-task-${var.name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 2048
  memory = 4096

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "frontend"
      image = var.frontend_image

      portMappings = [{
        containerPort = 3000
        hostPort      = 3000
        protocol      = "tcp"
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.frontend_log_group.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "frontend"
        }
      }
    }
  ])
  depends_on = [ aws_cloudwatch_log_group.frontend_log_group ]
}

resource "aws_cloudwatch_log_group" "backend_log_group" {
  name              = "/ecs/backend-${var.name}"
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "backend-task-${var.name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = 512
  memory = 1024

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "backend"
      image = var.backend_image

      portMappings = [{
        containerPort = 5000
        hostPort      = 5000
        protocol      = "tcp"
      }]

      environment = [
      {
        name  = "NODE_ENV"
        value = "production"
      },
      {
        name  = "PORT"
        value = "5000"
      },
      {
        name      = "MONGO_URI"
         value = "${var.secret_arn}:MONGO_URI::"
      },
      {
        name      = "JWT_SECRET"
        value = "${var.secret_arn}:JWT_SECRET::"
      }
    ]

    # secrets = [
    #   {
    #     name      = "MONGO_URI"
    #      valueFrom = "${var.secret_arn}:MONGO_URI::"
    #   },
    #   {
    #     name      = "JWT_SECRET"
    #     valueFrom = "${var.secret_arn}:JWT_SECRET::"
    #   }
    # ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend_log_group.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "backend"
        }
      }
    }
  ])
  depends_on = [ aws_cloudwatch_log_group.backend_log_group ]
}