# terraform/modules/monitoring/variables.tf

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

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group (used for CPU alarm dimension)"
  type        = string
  default     = ""
}
