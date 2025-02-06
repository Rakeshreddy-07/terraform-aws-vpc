resource "aws_vpc_peering_connection" "default" {
  count = var.is_peering_required ? 1 : 0
  vpc_id        = aws_vpc.main.id
  peer_vpc_id   = local.default_vpc
  auto_accept   = true

  tags = merge(
    var.common_tags,
    var.vpc_peering_tags,
    {
    Name = "${local.resource_name}-default"
  }
  )
}


#add route to public route table expense vpc
resource "aws_route" "expense_vpc_public_route" {
    count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = local.default_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}

#add route to private route table expense vpc
resource "aws_route" "expense_vpc_private_route" {
    count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = local.default_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}


#add route to main route table default vpc
resource "aws_route" "default_vpc_main_route" {
    count = var.is_peering_required ? 1 : 0
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = aws_vpc.main.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}
