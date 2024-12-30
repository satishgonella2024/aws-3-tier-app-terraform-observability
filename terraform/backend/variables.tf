variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "backend_image" {
  description = "Docker image for the backend"
  type        = string
}

variable "execution_role_arn" {
  description = "Execution role ARN for ECS tasks"
  type        = string
}

variable "task_role_arn" {
  description = "Task role ARN for ECS tasks"
  type        = string
}

variable "backend_subnets" {
  description = "Subnets for the backend ECS service"
  type        = list(string)
}

variable "backend_security_groups" {
  description = "Security groups for the backend ECS service"
  type        = list(string)
}
