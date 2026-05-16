# terraform/modules/networking/variables.tf

variable "project_name" {
  description = "Name prefix used for all resources"
  type        = string
  default     = "starttech"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet 1 (AZ-a)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2 (AZ-b) — required for ALB"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "az_1" {
  description = "Primary availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "az_2" {
  description = "Secondary availability zone (used by ALB and subnet 2)"
  type        = string
  default     = "us-east-1b"
}

variable "ssh_allowed_cidr" {
  description = "CIDR that is allowed to SSH into EC2 instances. Use your IP e.g. 1.2.3.4/32"
  type        = string
  default     = "0.0.0.0/0" # Lock this down before submission!
}
