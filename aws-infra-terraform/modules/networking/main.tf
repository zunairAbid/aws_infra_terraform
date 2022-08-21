# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name  = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-vpc"
  }
}

# Subnets Public and Private

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-igw"
  }
}

# EIP for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = {
    Name        = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-nat"

  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.vpc.availability_zones)
  cidr_block              = element(var.vpc.public-subnet, count.index)
  availability_zone       = element(var.vpc.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name  = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.vpc.availability_zones)
  cidr_block              = element(var.vpc.private-subnet, count.index)
  availability_zone       = element(var.vpc.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name   = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-private-subnet"
  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name   = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-private-route-table"

  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name   = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-public-route-table"
    Environment = "${terraform.workspace}"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.igw.id
}

# Route for NAT Gateway
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Route table (RT) associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.vpc.public-subnet)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.vpc.private-subnet)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

# Default Security Group of VPC
resource "aws_security_group" "default" {
  name    = "${var.global_variables.project}-${var.global_variables.app}-${terraform.workspace}-default-sg"
  description = "Default SG"
  vpc_id      = aws_vpc.vpc.id
  depends_on = [
    aws_vpc.vpc
  ]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Environment = "${terraform.workspace}"
  }
}