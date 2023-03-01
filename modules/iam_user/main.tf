data "local_file" "pgp_key" {
  filename = "${path.module}/public-key-binary-terraform.gpg"
}

resource "aws_iam_user" "this" {
  count = var.create_user ? 1 : 0

  name = var.name
  path = var.path
  tags = merge(var.tags, {Managed = "terraform"})
  force_destroy = var.force_destroy
}

resource "aws_iam_user_login_profile" "this" {
  count = var.create_login ? 1 : 0

  user                    = aws_iam_user.this[0].name
  pgp_key                 = data.local_file.pgp_key.content_base64

  lifecycle {
    ignore_changes = [password_reset_required]
  }
}

resource "aws_iam_access_key" "this" {
  count = var.create_accesskey ? 1 : 0

  user                    = aws_iam_user.this[0].name
  pgp_key                 = data.local_file.pgp_key.content_base64
}


resource "aws_iam_user_group_membership" "group_membership" {
  count      = length(var.groups) > 0 ? 1 : 0

  user       = aws_iam_user.this[0].name
  groups     = var.groups
  depends_on = [aws_iam_user.this]
}

resource "aws_iam_user_policy_attachment" "policies" {
  count        = length(var.policies) > 0 ? length(var.policies) : 0
  user         = aws_iam_user.this[0].name
  policy_arn   = var.policies[count.index]
  depends_on   = [aws_iam_user.this]
}
