#Default#
provider "aws" {
  region  = "eu-west-1"
  allowed_account_ids = [
    var.account_id
    ]
  profile = var.account_profile
}

###Using S3 bucket and DynamoDB to manage the terraform states###
terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "example-terraform-state"
    key            = "elasticsearch/state"
    region         = "eu-west-1"
    dynamodb_table = "terraform"
role_arn       = "arn:aws:iam::00000000:role/terraform-state"
  }
}

data "aws_caller_identity" "current" {}