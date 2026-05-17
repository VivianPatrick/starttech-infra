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

# ─────────────────────────────────────────────
# ElastiCache variables
# ─────────────────────────────────────────────
variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ElastiCache subnet group"
  type        = list(string)
}

variable "redis_sg_id" {
  description = "Security group ID for ElastiCache Redis (from networking module)"
  type        = string
}

variable "redis_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"
}
