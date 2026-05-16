# terraform/modules/monitoring/outputs.tf

output "iam_instance_profile_name" {
  description = "IAM instance profile name — pass to compute module"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "iam_role_arn" {
  description = "ARN of the EC2 CloudWatch IAM role"
  value       = aws_iam_role.ec2_cloudwatch_role.arn
}

output "backend_log_group_name" {
  description = "CloudWatch log group name for the backend"
  value       = aws_cloudwatch_log_group.backend.name
}

output "frontend_log_group_name" {
  description = "CloudWatch log group name for the frontend"
  value       = aws_cloudwatch_log_group.frontend.name
}

output "application_log_group_name" {
  description = "CloudWatch log group name for the application"
  value       = aws_cloudwatch_log_group.application.name
}
