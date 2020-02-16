output "pcx_id" {
  value = aws_vpc_peering_connection.pcx.id
}

output "peer_vpc" {
  value = local.peer_vpc
}

output "local_vpc" {
  value = local.local_vpc
}
