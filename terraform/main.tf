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
