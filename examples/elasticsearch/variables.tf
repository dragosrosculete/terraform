#Global Variables#
variable "account_name" {
  type    = string
  default = "example"
}

variable "account_id" {
  type    = string
  default = "000000000"
}

variable "account_profile" {
  type    = string
  default = "example"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.24.0"
    }
    external = {
      source = "hashicorp/external"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.12.1"
    }
  }
  required_version = ">= 1.2.6"
}

variable "route53_hostzone" {
  type    = string
  default = "ZZZZZZZZZZ"
}