output "this_iam_user_name" {
  description = "The user's name"
  value       = element(concat(aws_iam_user.this.*.name, [""]), 0)
}

output "this_iam_user_login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value = element(
    concat(aws_iam_user_login_profile.this.*.encrypted_password, [""]),
    0,
  )
}

output "this_iam_user_accesskey" {
  description = "The user's name accesskey"
  value       = element(concat(aws_iam_access_key.this.*.id, [""]), 0)
}

output "this_iam_user_accesskey_encrypted_secret" {
  description = "The encrypted accesskey, base64 encoded"
  value = element(
    concat(aws_iam_access_key.this.*.encrypted_secret, [""]),
    0,
  )
}
