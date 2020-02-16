data "aws_vpc" "peer" {
  count = local.lookup_peer ? 1 : 0

  tags = {
    Name = var.peer_vpc_name
  }
}

data "aws_vpc" "local" {
  count = local.lookup_local ? 1 : 0

  tags = {
    Name = var.local_vpc_name
  }
}

data "aws_route_tables" "peer" {
  count  = local.lookup_peer ? 1 : 0
  vpc_id = data.aws_vpc.peer[count.index].id

  dynamic "filter" {
    for_each = var.peer_rtb_filters

    content {
      name   = filter.name
      values = filter.values
    }
  }
}

data "aws_route_tables" "local" {
  count  = local.lookup_local ? 1 : 0
  vpc_id = data.aws_vpc.local[count.index].id

  dynamic "filter" {
    for_each = var.local_rtb_filters

    content {
      name   = filter.name
      values = filter.values
    }
  }
}

locals {
  lookup_peer  = var.peer_vpc == null && var.peer_vpc_name != null
  lookup_local = var.local_vpc == null && var.local_vpc_name != null

  local_vpc = var.local_vpc != null ? var.local_vpc : {
    id      = data.aws_vpc.local[0].id
    cidr    = data.aws_vpc.local[0].cidr_block
    rtb_ids = data.aws_route_tables.local[0].ids
  }

  peer_vpc = var.peer_vpc != null ? var.peer_vpc : {
    id      = data.aws_vpc.peer[0].id
    cidr    = data.aws_vpc.peer[0].cidr_block
    rtb_ids = data.aws_route_tables.peer[0].ids
  }

  tags = {
    Terraform = true,
  }
}

resource "aws_vpc_peering_connection" "pcx" {
  vpc_id      = local.local_vpc.id
  peer_vpc_id = local.peer_vpc.id
  auto_accept = true
  tags        = local.tags
}

resource "aws_route" "peer_to_local" {
  for_each                  = toset(local.peer_vpc.rtb_ids)
  route_table_id            = each.value
  destination_cidr_block    = local.local_vpc.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.pcx.id
}

resource "aws_route" "local_to_peer" {
  for_each                  = toset(local.local_vpc.rtb_ids)
  route_table_id            = each.value
  destination_cidr_block    = local.peer_vpc.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.pcx.id
}
