  # terraform/modules/compute/outputs.tf

output "instance_id" {
  description = "ID of the standalone EC2 instance"
  value       = aws_instance.app_server.id
}

output "public_ip" {
  description = "Public IP of the standalone EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "private_ip" {
  description = "Private IP of the standalone EC2 instance"
  value       = aws_instance.app_server.private_ip
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app.arn
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.app.arn
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}
