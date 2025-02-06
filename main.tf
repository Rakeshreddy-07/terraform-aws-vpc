resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
    enable_dns_hostnames = var.dns_hostnames


  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = local.resource_name
    }
  )
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
    Name = local.resource_name
  }
  )
}

#public subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidr, count.index)
  availability_zone = element(local.az_names, count.index)
  map_public_ip_on_launch = true

  #expense-dev-public-us-east-1a/b
  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
    Name = "${local.resource_name}-public-${local.az_names[count.index]}"
  }
  )
}

#private subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.private_subnet_cidr, count.index)
  availability_zone = element(local.az_names, count.index)

  #expense-dev-public-us-east-1a/b
  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
    Name = "${local.resource_name}-private-${local.az_names[count.index]}"
  }
  )
}

#database subnet
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.database_subnet_cidr, count.index)
  availability_zone = element(local.az_names, count.index)

  #expense-dev-public-us-east-1a/b
  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
    Name = "${local.resource_name}-database-${local.az_names[count.index]}"
  }
  )
}

#Elastic IP
resource "aws_eip" "nat" {
  domain   = "vpc"
}

#NAT
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.nat_gw_tags,
    {
    Name = local.resource_name
  }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

#route table public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

    tags = merge(
      var.common_tags,
      var.public_route_table_tags,
      {
    Name = "${local.resource_name}-public"
  }
    )
}

#route table private
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

    tags = merge(
      var.common_tags,
      var.private_route_table_tags,
      {
    Name = "${local.resource_name}-private"
  }
    )
}

#route table database
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

    tags = merge(
      var.common_tags,
      var.database_route_table_tags,
      {
    Name = "${local.resource_name}-database"
  }
    )
}

#add route in public route table
resource "aws_route" "igw_public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

#add route in private route table
resource "aws_route" "nat_private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}


#add route in database route table
resource "aws_route" "nat_database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}

#subnet association - 
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}