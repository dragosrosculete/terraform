#account_a region us-east-2
provider "aws" {
  region = "us-east-2"
  alias = "account_a_us_east_2"
  assume_role {
    role_arn = "arn:aws:iam::00000000:role/terraform"
  }
}

#account_b region eu-west-1
provider "aws" {
  region = "eu-west-1"
  alias = "account_b_eu_west_1"
  assume_role {
    role_arn = "arn:aws:iam::11111111:role/terraform"
  }
}

#account_b region us-east-2
provider "aws" {
  region = "us-east-2"
  alias = "account_b_us_east_2"
  assume_role {
    role_arn = "arn:aws:iam::11111111:role/terraform"
  }
}

#State can be in a different account
terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "terraform-state"
    key            = "global/network/state"
    region         = "eu-west-1"
    dynamodb_table = "terraform"
    role_arn       = "arn:aws:iam::33333333:role/terraform"
  }
}

data "terraform_remote_state" "account_a_us_east_2_network" {
  backend = "s3"
  config = {
    bucket   = "terraform-state"
    key      = "account_a/us_east_2/network/state"
    region   = "eu-west-1"
    "arn:aws:iam::33333333:role/terraform"
  }
}


data "terraform_remote_state" "account_b_eu_west_1_network" {
  backend = "s3"
  config = {
    bucket   = "terraform-state"
    key      = "account_b/eu-west-1/network/state"
    region   = "eu-west-1"
    "arn:aws:iam::33333333:role/terraform"
  }
}


data "terraform_remote_state" "account_b_us_east_2_network" {
  backend = "s3"
  config = {
    bucket   = "terraform-state"
    key      = "account_b/us-east-2/network/state"
    region   = "eu-west-1"
    "arn:aws:iam::33333333:role/terraform"
  }
}
