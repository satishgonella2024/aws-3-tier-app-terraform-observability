variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  default     = "dev"
}

variable "project" {
  description = "Project name"
  default     = "terraform-bootstrap"
}

variable "bucket_prefix" {
  description = "Prefix for S3 bucket name"
  default     = "terraform-state"
}

variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    "Owner"       = "Satish"
    "Environment" = "dev"
    "Project"     = "terraform-bootstrap"
  }
}
