#account_a_us_east_2_to_account_b_us_east_2
resource "aws_vpc_peering_connection" "req_account_a_us_east_2_to_account_b_us_east_2" {
  provider = aws.account_a_us_east_2
  vpc_id        = data.terraform_remote_state.account_a_us_east_2_network.outputs.vpc_us_east_2
  peer_vpc_id   = data.terraform_remote_state.account_b_us_east_2_network.outputs.vpc_us_east_2
  peer_owner_id = var.account_b
  auto_accept   = false

  tags = {
    Name    = "account_a_us_east_2_to_account_b_us_east_2"
    Managed = "terraform"
  }
}

resource "aws_vpc_peering_connection_accepter" "acc_account_a_us_east_2_to_account_b_us_east_2" {
  provider = aws.account_b_us_east_2
  vpc_peering_connection_id = aws_vpc_peering_connection.req_account_a_us_east_2_to_account_b_us_east_2.id
  auto_accept               = true

  tags = {
    Name    = "account_a_us_east_2_to_account_b_us_east_2"
    Managed = "terraform"
  }
}

resource "aws_vpc_peering_connection_options" "req_account_a_us_east_2_to_account_b_us_east_2" {
  provider = aws.account_a_us_east_2
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.acc_account_a_us_east_2_to_account_b_us_east_2.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  depends_on = [ aws_vpc_peering_connection_accepter.acc_account_a_us_east_2_to_account_b_us_east_2 ]
}

resource "aws_vpc_peering_connection_options" "acc_account_a_us_east_2_to_account_b_us_east_2" {
  provider = aws.account_b_us_east_2
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.acc_account_a_us_east_2_to_account_b_us_east_2.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  depends_on = [ aws_vpc_peering_connection_accepter.acc_account_a_us_east_2_to_account_b_us_east_2 ]
}



#account_a_us_east_2_to_account_b_eu_west_1
resource "aws_vpc_peering_connection" "req_account_a_us_east_2_to_account_b_eu_west_1" {
  provider      = aws.account_a_us_east_2
  vpc_id        = data.terraform_remote_state.account_a_us_east_2_network.outputs.vpc_us_east_2
  peer_vpc_id   = data.terraform_remote_state.account_b_us_east_2_network.outputs.vpc_eu_west_1
  peer_owner_id = var.account_b
  peer_region   = "eu-west-1"
  auto_accept   = false
  tags = {
    Name    = "account_a_us_east_2_to_account_b_eu_west_1"
    Managed = "terraform"
  }
}

resource "aws_vpc_peering_connection_accepter" "acc_account_a_us_east_2_to_account_b_eu_west_1" {
  provider = aws.account_b_eu_west_1
  vpc_peering_connection_id = aws_vpc_peering_connection.req_account_a_us_east_2_to_account_b_eu_west_1.id
  auto_accept               = true
  tags = {
    Name    = "account_a_us_east_2_to_account_b_eu_west_1"
    Managed = "terraform"
  }
}

resource "aws_vpc_peering_connection_options" "req_account_a_us_east_2_to_account_b_eu_west_1" {
  provider      = aws.account_a_us_east_2
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.acc_account_a_us_east_2_to_account_b_eu_west_1.id
  requester {
    allow_remote_vpc_dns_resolution = true
  }
  depends_on = [ aws_vpc_peering_connection_accepter.acc_account_a_us_east_2_to_account_b_eu_west_1 ]
}

resource "aws_vpc_peering_connection_options" "acc_account_a_us_east_2_to_account_b_eu_west_1" {
  provider = aws.account_b_eu_west_1
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.acc_account_a_us_east_2_to_account_b_eu_west_1.id
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  depends_on = [ aws_vpc_peering_connection_accepter.acc_account_a_us_east_2_to_account_b_eu_west_1 ]
}