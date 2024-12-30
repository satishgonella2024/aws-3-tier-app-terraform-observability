output "bucket_name" {
  description = "The S3 bucket name for Terraform state"
  value       = "terraform-state-obcdegyj"
}

output "dynamodb_table_name" {
  description = "The DynamoDB table name for Terraform locks"
  value       = "terraform-bootstrap-dev-locks"
}

output "frontend_subnet_ids" {
  value = aws_subnet.frontend[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "frontend_security_group_id" {
  value = aws_security_group.frontend.id
}

output "alb_arn" {
  description = "ARN of the frontend Application Load Balancer"
  value       = module.frontend.alb_arn
}

output "alb_dns_name" {
  description = "DNS name of the frontend Application Load Balancer"
  value       = module.frontend.alb_dns_name
}

output "alb_listener_arn" {
  description = "ARN of the frontend ALB listener"
  value       = module.frontend.alb_listener_arn
}

