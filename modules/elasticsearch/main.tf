data "aws_caller_identity" "current" {}

#SG
resource "aws_security_group" "this" {
  count = var.create_elasticsearch ? 1 : 0
  name        = var.es_cluster_name
  description = var.es_cluster_name

  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description              = "Allow access from internal network"
    protocol                 = "tcp"
    from_port                = 0
    to_port                  = 65535
    cidr_blocks              = ["10.0.0.0/8"]
  }

  ingress {
    description              = "Allow access from internal network"
    protocol                 = "tcp"
    from_port                = 0
    to_port                  = 65535
    cidr_blocks              = ["172.16.0.0/12"]
  }

  ingress {
    description              = "Allow access from internal network"
    protocol                 = "tcp"
    from_port                = 0
    to_port                  = 65535
    cidr_blocks              = ["192.168.0.0/16"]
  }

  tags = var.tags
}

#ES#
resource "aws_elasticsearch_domain" "this" {
  count = var.create_elasticsearch ? 1 : 0

  domain_name           = var.es_cluster_name
  elasticsearch_version = var.es_version

  timeouts {
    update = var.es_timeout_update
    create = var.es_timeout_create
    delete = var.es_timeout_delete
  }

  cluster_config {
    instance_type            = var.es_instance_type
    instance_count           = var.es_instance_count
    dedicated_master_enabled = var.es_dedicated_master_enabled
    zone_awareness_enabled   = var.es_zone_awareness_enabled
  }

  ebs_options {
    ebs_enabled = var.es_volume_size > 0 ? true : false
    volume_size = var.es_volume_size > 0 ? var.es_volume_size : null
    volume_type = var.es_volume_size > 0 ? var.es_volume_type : null
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  vpc_options {
    security_group_ids = [ aws_security_group.this[0].id ]
    subnet_ids         = var.subnet_ids
  }

  advanced_options = var.advanced_options

  node_to_node_encryption {
    enabled = var.node_to_node_encryption
  }

  encrypt_at_rest {
    enabled = var.encrypt_at_rest
  }

  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:*:${data.aws_caller_identity.current.account_id}:domain/${var.es_cluster_name}/*"
    }
  ]
}
POLICY

  tags = var.tags

  lifecycle {
    ignore_changes = [log_publishing_options]
  }
}

#Route 53 record#
resource "aws_route53_record" "this" {
  count = var.create_elasticsearch && var.create_elasticsearch_dns ? 1 : 0

  zone_id = var.es_route53_hostzone
  name    = var.es_route53_dns
  type    = "CNAME"
  ttl     = "60"
  records = [aws_elasticsearch_domain.this[0].endpoint]
}

resource "null_resource" "set_default_template" {
  triggers = {
    number_of_shards   = var.default_shards
    number_of_replicas = var.default_replicas
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
        curl -XPUT ${aws_route53_record.this[0].name}/_template/index_defaults -H 'Content-Type: application/json' -d'
{
    "index_patterns": "*", 
    "settings" : {
        "index" : {
            "number_of_shards" : ${var.default_shards},
            "number_of_replicas" : ${var.default_replicas}
        }
    }
}'
EOT
  }
}

resource "null_resource" "set_indeces_lifecycle" {
  triggers = {
    delete_index_older_than  = var.delete_index_older_than
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    on_failure = "continue"
    command     = <<EOT
    curl -XDELETE ${aws_route53_record.this[0].name}/_opendistro/_ism/policies/delete_old_indices
    curl -XPUT ${aws_route53_record.this[0].name}/_opendistro/_ism/policies/delete_old_indices -H 'Content-Type: application/json' -d'
    {
      "policy": {
        "description": "Delete old indices.",
        "schema_version": 1,
        "default_state": "current",
        "ism_template": {
          "index_patterns": ["logstash*", "aerospike*"],
          "priority": 100
        },
        "states": [{
            "name": "current",
            "actions": [],
            "transitions": [{
              "state_name": "delete",
              "conditions": {
                "min_index_age": "${var.delete_index_older_than}d"
              }
            }]
          },
          {
            "name": "delete",
            "actions": [{
              "delete": {}
            }],
            "transitions": []
          }
        ]
      }
    }
    }'
EOT
  }
}