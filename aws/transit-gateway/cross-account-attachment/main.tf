locals {
  name                       = var.name
  ram_resource_share_tgw_arn = var.ram_resource_share_tgw_arn
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.subnet_ids
  transit_gateway_id         = var.transit_gateway_id
  routing_table_ids          = var.routing_table_ids
  tgw_endpoint_subnet_ids    = var.tgw_endpoint_subnet_ids
  tags                       = merge(var.additional_tags, {})
}

data "aws_ec2_transit_gateway" "shared_tgw" {
  provider = aws.cp
  filter {
    name   = "transit-gateway-id"
    values = [local.transit_gateway_id]
  }
}

data "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  count = strcontains(local.name, "dp") ? 1 : 0
  provider = aws.dp
  filter {
    name   = "tag:Name"
    values = ["dp-an2-tgw-rt"]
  }
}

data "aws_ec2_transit_gateway_route_table" "cp_tgw_rt" {
  count = strcontains(local.name, "cp") ? 1 : 0
  provider = aws.cp
  filter {
    name   = "tag:Name"
    values = ["cp-an2-tgw-rt"]
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  count = strcontains(local.name, "dp") ? 1 : 0

  provider = aws.dp

  subnet_ids                                      = local.tgw_endpoint_subnet_ids
  transit_gateway_id                              = data.aws_ec2_transit_gateway.shared_tgw.id
  vpc_id                                          = local.vpc_id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true

  lifecycle {
    ignore_changes = [transit_gateway_default_route_table_association, transit_gateway_default_route_table_propagation]
  }

  tags = local.tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "cp_tgw_attachment" {
  count = strcontains(local.name, "cp") ? 1 : 0

  provider = aws.cp

  subnet_ids                                      = local.tgw_endpoint_subnet_ids
  transit_gateway_id                              = data.aws_ec2_transit_gateway.shared_tgw.id
  vpc_id                                          = local.vpc_id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  lifecycle {
    ignore_changes = [transit_gateway_default_route_table_association, transit_gateway_default_route_table_propagation]
  }

  tags = local.tags
}

resource "aws_route" "tgw_route" {
  count = strcontains(local.name, "dp") ? length(local.routing_table_ids) : 0

  provider = aws.dp

  route_table_id         = local.routing_table_ids[count.index]
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = local.transit_gateway_id
}

resource "aws_route" "cp_tgw_route" {
  count = strcontains(local.name, "cp") ? length(local.routing_table_ids) : 0

  provider = aws.cp

  route_table_id         = local.routing_table_ids[count.index]
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = local.transit_gateway_id
}

resource "aws_route_table_association" "tgw_route_table_association" {
  count = strcontains(local.name, "dp") ? length(local.routing_table_ids) : 0

  provider = aws.dp

  subnet_id      = local.tgw_endpoint_subnet_ids[count.index]
  route_table_id = local.routing_table_ids[count.index]

  lifecycle {
    ignore_changes = [subnet_id, route_table_id]
  }
}

resource "aws_route_table_association" "cp_tgw_route_table_association" {
  count = strcontains(local.name, "cp") ? length(local.routing_table_ids) : 0

  provider = aws.cp

  subnet_id      = local.tgw_endpoint_subnet_ids[count.index]
  route_table_id = local.routing_table_ids[count.index]

  lifecycle {
    ignore_changes = [subnet_id, route_table_id]
  }
}
