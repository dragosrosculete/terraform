variable "create_user" {
  description = "Whether to create the IAM user"
  type        = bool
  default     = true
}

variable "create_login" {
  description = "Whether to create a login password for the user"
  type        = bool
  default     = false
}

variable "create_accesskey" {
  description = "Whether to create an access and secret key for the user"
  type        = bool
  default     = false
}

variable "name" {
  description = "Desired name for the IAM user"
  type        = string
}

variable "path" {
  description = "Desired path for the IAM user"
  type        = string
  default     = "/"
}

variable "force_destroy" {
  description = "Allow user to be destroyed from terraform even if resources from outisde were added"
  type        = string
  default     = "true"
}

variable "allow-sts-from" {
  description = "policy"
  type        = string
  default     = ""
}

variable "manage-own-account" {
  description = "policy"
  type        = string
  default     = ""
}

variable "pgp_key" {
  description = "Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Used to encrypt password and access key. `pgp_key` is required when `create_iam_user_login_profile` is set to `true`"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {
    Managed = "terraform"
  }
}

variable "groups" {
  description = "List of IAM user groups this user should belong to in the account"
  type        = list(string)
  default     = []
}

variable "policies" {
  description = "Existing policy ARNs to attach to the IAM user"
  type        = list(string)
  default     = []
}
