output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.frontend_lb.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.frontend_lb.dns_name
}

output "alb_listener_arn" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.frontend_listener.arn
}
