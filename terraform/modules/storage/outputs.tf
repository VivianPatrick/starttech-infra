# terraform/modules/storage/outputs.tf

# ─────────────────────────────────────────────
# S3 outputs
# ─────────────────────────────────────────────
output "bucket_name" {
  description = "S3 bucket name — used by frontend CI/CD to sync build files"
  value       = aws_s3_bucket.frontend.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.frontend.arn
}

# ─────────────────────────────────────────────
# CloudFront outputs — disabled pending AWS account verification
# ─────────────────────────────────────────────
output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (pending account verification)"
  value       = ""
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name (pending account verification)"
  value       = "pending-cloudfront-verification"
}

output "website_url" {
  description = "Frontend URL (pending CloudFront verification)"
  value       = "pending-cloudfront-verification"
}

# ─────────────────────────────────────────────
# ElastiCache outputs
# ─────────────────────────────────────────────
output "redis_endpoint" {
  description = "Redis cluster endpoint — used by backend to connect"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_port" {
  description = "Redis port"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].port
}