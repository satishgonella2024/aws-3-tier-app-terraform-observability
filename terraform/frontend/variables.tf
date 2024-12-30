variable "project" {
  description = "Project name for tagging"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
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
