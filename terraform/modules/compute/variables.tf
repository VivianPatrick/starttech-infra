# terraform/modules/compute/variables.tf

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "starttech"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "public_subnet_id" {
  description = "First public subnet ID (AZ-a)"
  type        = string
}

variable "public_subnet_2_id" {
  description = "Second public subnet ID (AZ-b) — required by ALB and ASG"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID — required by target group"
  type        = string
}

variable "ec2_sg_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for EC2 CloudWatch access"
  type        = string
  default     = ""
}

variable "asg_desired" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 2
}

variable "asg_min" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 4
}
