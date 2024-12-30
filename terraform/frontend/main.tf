resource "aws_lb" "frontend_lb" {
# Shortened name to fit within AWS's 32-character limit
  name               = "${substr(var.project, 0, 10)}-fe-lb-${var.environment}"
  load_balancer_type = "application"
  security_groups    = var.frontend_security_groups
  subnets            = var.frontend_subnets
  enable_deletion_protection = false

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.frontend_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Frontend application is running"
      status_code  = "200"
    }
  }
}


