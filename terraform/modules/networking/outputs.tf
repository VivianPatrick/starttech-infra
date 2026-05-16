# terraform/modules/networking/outputs.tf

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of public subnet 1 (AZ-a)"
  value       = aws_subnet.public_subnet.id
}

output "public_subnet_2_id" {
  description = "ID of public subnet 2 (AZ-b) — used by ALB"
  value       = aws_subnet.public_subnet_2.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

output "alb_sg_id" {
  description = "Security group ID for the Application Load Balancer"
  value       = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
  description = "Security group ID for EC2 backend instances"
  value       = aws_security_group.ec2_sg.id
}

output "redis_sg_id" {
  description = "Security group ID for ElastiCache Redis"
  value       = aws_security_group.redis_sg.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}
