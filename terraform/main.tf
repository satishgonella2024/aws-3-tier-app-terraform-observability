terraform {
  backend "s3" {
    bucket         = "terraform-state-obcdegyj"  # Replace with your bucket name
    key            = "main/terraform.tfstate"
    region         = "eu-west-2"                # Replace with your region
    dynamodb_table = "terraform-bootstrap-dev-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Fetch available AZs in the region
data "aws_availability_zones" "available" {}

# VPC and Networking Setup
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "sample-3-tier-vpc"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "sample-3-tier-igw"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "sample-3-tier-rt"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_subnet" "frontend" {
  count = 2 # Create two subnets, one in each availability zone

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "frontend-subnet-${count.index}"
    Environment = var.environment
    Project     = var.project
    Role        = "frontend"
  }
}

resource "aws_route_table_association" "frontend" {
  count          = length(aws_subnet.frontend[*].id)
  subnet_id      = aws_subnet.frontend[count.index].id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "frontend" {
  name        = "${var.project}-frontend-sg"
  description = "Allow HTTP and HTTPS traffic to frontend"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-frontend-sg"
    Environment = var.environment
    Project     = var.project
  }
}

# ECS Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
      },
    ]
  })

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
      },
    ]
  })

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}


# Module for Frontend Resources
module "frontend" {
  source                  = "./frontend"
  project                 = var.project
  environment             = var.environment
  frontend_subnets        = aws_subnet.frontend[*].id
  frontend_security_groups = [aws_security_group.frontend.id]
}

module "backend" {
  source                  = "./backend"
  project                 = var.project
  environment             = var.environment
  backend_image           = "satish2024/aws-3-tier-app-backend:latest"
  execution_role_arn      = aws_iam_role.ecs_execution_role.arn
  task_role_arn           = aws_iam_role.ecs_task_role.arn
  backend_subnets         = aws_subnet.frontend[*].id
  backend_security_groups = [aws_security_group.frontend.id]
}



