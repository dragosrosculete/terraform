output "cloudfront_distribution_id" {
  description = "The identifier for the distribution."
  value       = try(aws_cloudfront_distribution.this[0].id, "")
}

output "aws_wafv2_web_acl_id" {
  description = "The identifier for the ACL."
  value       = try(aws_wafv2_web_acl.this[0].id, "")
}