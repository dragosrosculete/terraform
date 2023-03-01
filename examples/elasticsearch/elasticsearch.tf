resource "aws_iam_service_linked_role" "elasticsearch" {
  aws_service_name = "es.amazonaws.com"
}

#Create a full stack containing: ElasticSearch Cluster, SG, Route53, IAM, Lambda, Cloudwatch Events.
module "elk-example" {
  source = "../modules/elasticsearch"
  es_timeout_create = "360m"
  es_timeout_update = "360m"
  es_timeout_delete = "360m"
  vpc_id = "vpc-adssd718"
  subnet_ids =  [
    "subnet-01dsadasdsa2e68614"
  ]

  es_cluster_name      = "elk-example"
  es_route53_hostzone = var.route53_hostzone
  es_route53_dns = "elk-example.com"

  es_version       = "OpenSearch_2.3"
  es_instance_type = "i3.2xlarge.elasticsearch"
  es_instance_count = "3"
  es_dedicated_master_enabled = "false"
  es_zone_awareness_enabled = "false"

  node_to_node_encryption = "false"
  encrypt_at_rest = "false"

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
    "override_main_response_version" = "true"
  }

  # es_volume_size = "16384"
  # es_volume_type = "gp3"

  default_shards = "6"
  default_replicas = "1"

  delete_index_older_than = "31"

  tags = {
    Managed = "Terraform"
    Name = "elk-example"
  }
}