variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "frontend_subnets" {
  description = "Subnets for the frontend load balancer"
  type        = list(string)
}

variable "frontend_security_groups" {
  description = "Security groups for the frontend load balancer"
  type        = list(string)
}

variable "execution_role_arn" {
  description = "Execution role ARN for ECS tasks"
  type        = string
}

variable "task_role_arn" {
  description = "Task role ARN for ECS tasks"
  type        = string
}

