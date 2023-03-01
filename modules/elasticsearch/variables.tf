variable "create_elasticsearch" {
  description = "Whether to create elasticsearch"
  type        = bool
  default     = true
}

variable "create_elasticsearch_dns" {
  description = "Whether to create elasticsearch dns"
  type        = bool
  default     = true
}

variable "vpc_id" {
  type    = string
}


variable "es_cluster_name" {
  description = "Desired name for elasticsearch"
  type        = string
}

variable "es_timeout_update" {
  description = "Timeout"
  type        = string
}

variable "es_timeout_create" {
  description = "Timeout"
  type        = string
}

variable "es_timeout_delete" {
  description = "Timeout"
  type        = string
}

variable "default_shards" {
  type    = number
  description = "Desired shards for elasticsearch"
}

variable "default_replicas" {
  type    = number
  description = "Desired replicas for elasticsearch"
}

variable "es_version" {
  description = "Desired version for elasticsearch"
  type        = string
}

variable "es_instance_count" {
  type    = number
  description = "Desired instance number for elasticsearch"
}

variable "es_instance_type" {
  type    = string
  description = "Desired instance type for elasticsearch"
}

variable "es_dedicated_master_enabled" {
  type    = string
  description = "Dedicated instance for elasticsearch"
}

variable "es_zone_awareness_enabled" {
  type    = string
  description = "Zone awareness for elasticsearch"
}

variable "es_volume_size" {
  type        = number
  default     = 0
  description = "EBS volumes for data storage in GB."
}

variable "es_volume_type" {
  type        = string
  default     = "gp2"
  description = "Storage type of EBS volumes."
}


variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnet IDs."
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security Group IDs."
}

variable "advanced_options" {
  type        = map(string)
  default     = {}
  description = "Key-value string pairs to specify advanced configuration options."
}

variable "node_to_node_encryption" {
  description = "node encryption"
  type = string
}

variable "encrypt_at_rest" {
  description = "encrypt_at_rest"
  type = string
}

variable "es_route53_hostzone" {
  description = "route53 hostzone"
  type = string
}

variable "es_route53_dns" {
  description = "route53 elasticsearch dns"
  type = string
}

variable "index" {
  description = "Index/indices to process using regex, except the one matching `skip_index` regex"
  default     = ".*"
  type        = string
}

variable "skip_index" {
  description = "Index/indices to skip"
  default     = ".kibana*"
  type        = string
}

variable "delete_index_older_than" {
  description = "Numbers of days to preserve"
  default     = "7"
  type        = number
}

variable "index_format" {
  description = "Combined with 'index' varible is used to evaluate the index age"
  default     = "%Y.%m.%d"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {
    Managed = "terraform"
  }
}
