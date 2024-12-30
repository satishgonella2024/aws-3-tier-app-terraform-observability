resource "aws_ecs_cluster" "backend" {
  name = "${var.project}-backend-cluster-${var.environment}"

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_ecs_task_definition" "backend_task" {
  family                   = "${var.project}-backend-task-${var.environment}"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = var.backend_image
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_ecs_service" "backend_service" {
  name            = "${var.project}-backend-service-${var.environment}"
  cluster         = aws_ecs_cluster.backend.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = var.backend_subnets
    security_groups = var.backend_security_groups
    assign_public_ip = true
  }

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}
