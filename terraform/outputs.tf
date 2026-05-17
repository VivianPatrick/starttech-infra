output "instance_id" {
  value = module.compute.instance_id
}

output "public_ip" {
  value = module.compute.public_ip
}

output "bucket_name" {
  value = module.storage.bucket_name
}

output "cloudfront_domain" {
  value = module.storage.cloudfront_domain_name
}

output "website_url" {
  value = module.storage.website_url
}

output "redis_endpoint" {
  value = module.storage.redis_endpoint
}