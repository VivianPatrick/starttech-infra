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
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "public_subnet_id" {
  description = "Subnet ID where EC2 instance will be launched"
  type        = string
}

variable "ec2_sg_id" {
  description = "Security group ID for EC2 instances (passed from networking module)"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for EC2 (passed from monitoring module)"
  type        = string
  default     = ""
}