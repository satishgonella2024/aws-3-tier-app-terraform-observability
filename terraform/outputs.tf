output "bucket_name" {
  description = "The S3 bucket name for Terraform state"
  value       = "terraform-state-obcdegyj"
}

output "dynamodb_table_name" {
  description = "The DynamoDB table name for Terraform locks"
  value       = "terraform-bootstrap-dev-locks"
}
