output "this_aws_route53_record" {
  description = "ES DNS"
  value       = element(concat(aws_route53_record.this.*.name, [""]), 0)
}