# terraform/modules/storage/outputs.tf

output "bucket_name" {
  description = "S3 bucket name — used by frontend CI/CD to sync build files"
  value       = aws_s3_bucket.frontend.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.frontend.arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID — used by CI/CD to invalidate cache"
  value       = aws_cloudfront_distribution.frontend.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name — the public URL of the frontend"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "website_url" {
  description = "Full HTTPS URL of the frontend"
  value       = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}
