# terraform/modules/storage/variables.tf

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
