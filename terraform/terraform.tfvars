project                 = "sample-3-tier-app"
environment             = "dev"
frontend_subnets        = ["subnet-abc123", "subnet-def456"]  # Replace with actual subnet IDs
frontend_security_groups = ["sg-xyz789"]                     # Replace with actual security group IDs
execution_role_arn = "arn:aws:iam::123456789012:role/ecsExecutionRole"
task_role_arn = "arn:aws:iam::123456789012:role/ecsTaskRole"
