//data "aws_availability_zones" "available_zones" {}

resource "aws_vpc" "skinai_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "skinai"
  }
}

# Public subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.skinai_vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available_zones.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "skinai_igw" {
  vpc_id = aws_vpc.skinai_vpc.id

  tags = {
    Name = "skinai igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.skinai_vpc.id

  tags = {
    Name = "Public RouteTable"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.skinai_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_route_association" {
  count       = length(aws_subnet.public_subnets[*].id)
  subnet_id   = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

# NAT Gateway and Private Subnets
resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)
  vpc   = true

  tags = {
    Name = "NAT EIP ${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = {
    Name = "NAT Gateway ${count.index + 1}"
  }
}

# Private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.skinai_vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(data.aws_availability_zones.available_zones.names, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.skinai_vpc.id

  tags = {
    Name = "Private RouteTable "
  }
}

resource "aws_route" "private_route" {
  count                = length(var.private_subnet_cidrs)
  route_table_id       = element(aws_route_table.private_route_table[*].id, count.index)
  nat_gateway_id       = aws_nat_gateway.nat_gateway[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_route_association" {
  count       = length(aws_subnet.private_subnets[*].id)
  subnet_id   = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.private_route_table[*].id, count.index)
}