terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.24.0"
    }
    external = {
      source = "hashicorp/external"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.12.1"
    }
  }
  required_version = ">= 1.2.6"
}

variable "account_assume_role_arn" {
  type    = string
  default = "arn:aws:iam::00000000:role/example"
}

variable "account_a" {
  type    = string
  default = "00000000"
}

variable "account_b" {
  type    = string
  default = "11111111"
}