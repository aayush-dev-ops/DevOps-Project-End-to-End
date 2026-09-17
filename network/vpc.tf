resource "aws_vpc" "ecom_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = merge(var.tags, {Name = "${var.environment_name}-vpc"})
  lifecycle {
    prevent_destroy = false
  }
}


resource "aws_internet_gateway" "ecom_igw" {
  vpc_id = aws_vpc.ecom-vpc.id
  tags = var.tags
}


resource "aws_subnet" "ecom_public_subnet" {
  for_each = { for idx, az in local.azs : az => local.public_subnets[idx] }
  vpc_id     = aws_vpc.ecom-vpc.id
  cidr_block = each.value
  availability_zone = each.key
  map_public_ip_on_launch = true
  tags = merge(var.tags , "${var.environment_name}-public_subnet-${each.key}")
}


resource "aws_subnet" "ecom_private_subnet" {
    for_each = { for idx, az in local.azs : az => local.private_subnets[idx]}
    vpc_id = aws_vpc.ecom_vpc.id
    cidr_block = each.value
    availability_zone = each.key
    tags = merge(var.tags , "${var.environment_name}-private_subnet-${each.key}")
}


resource "aws_eip" "ecom-eip" {
  tags = merge(var.tags , "${var.environment_name}-aws_elastic_ip")
}


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.example.id
  subnet_id     = values(aws_subnet.ecom_public_subnet)[0].id
  tags = merge(var.tags , "${var.environment_name}-nat_gateway")
  depends_on = [aws_internet_gateway.ecom_igw]
}


resource "aws_route_table" "ecom_public_route_table" {
  vpc_id = aws_vpc.ecom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecom_igw.id
  }
  tags = merge(var.tags , "${var.environment_name}-public-route_table")
}


resource "aws_route_table_association" "ecom_public_route_table_association" {
    for_each = aws_subnet.ecom_public_subnet
    subnet_id      = each.value.id
    route_table_id = aws_route_table.ecom_public_route_table.id
}


resource "aws_route_table" "ecom_private_route_table" {
  vpc_id = aws_vpc.ecom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(var.tags , "${var.environment_name}-private-route_table")
}


resource "aws_route_table_association" "ecom_private_route_table_association" {
    for_each = aws_subnet.ecom_private_subnet
    subnet_id      = each.value.id
    route_table_id = aws_route_table.ecom_private_route_table.id
}