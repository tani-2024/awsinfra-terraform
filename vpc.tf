resource "aws_vpc" "dove" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "dove-vpc"
  }
}

resource "aws_subnet" "dove-pub-1" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "dove-pub-1"
  }
}

resource "aws_subnet" "dove-pub-2" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "dove-pub-2"
  }
}

resource "aws_subnet" "dove-priv-1" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE1
  tags = {
    Name = "dove-priv-1"
  }
}


resource "aws_subnet" "dove-priv-2" {
  vpc_id                  = aws_vpc.dove.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.ZONE2
  tags = {
    Name = "dove-priv-2"
  }
}

resource "aws_internet_gateway" "dove-IGW" {
  vpc_id = aws_vpc.dove.id
  tags = {
    Name = "dove-IGW"
  }
}

resource "aws_route_table" "dove-pub-RT" { #
  vpc_id = aws_vpc.dove.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dove-IGW.id
  }

  tags = {
    Name = "dove-pub-RT"
  }
}


resource "aws_route_table_association" "dove-pub-1-a" {
  subnet_id      = aws_subnet.dove-pub-1.id
  route_table_id = aws_route_table.dove-pub-RT.id
}

resource "aws_route_table_association" "dove-pub-2-a" {
  subnet_id      = aws_subnet.dove-pub-2.id
  route_table_id = aws_route_table.dove-pub-RT.id
}

resource "aws_eip" "dove" {
  domain = "vpc"
}

resource "aws_nat_gateway" "dove" {
  allocation_id = aws_eip.dove.id
  subnet_id     = aws_subnet.dove-pub-1.id
  tags = {
    Name = "dove-nat-gateway"
  }
}

resource "aws_route_table" "dove-priv-RT" {
  vpc_id = aws_vpc.dove.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dove.id
  }

  tags = {
    Name = "dove-priv-RT"
  }
}

resource "aws_route_table_association" "dove-priv-1-a" {
  subnet_id      = aws_subnet.dove-priv-1.id
  route_table_id = aws_route_table.dove-priv-RT.id
}

resource "aws_route_table_association" "dove-priv-2-a" {
  subnet_id      = aws_subnet.dove-priv-2.id
  route_table_id = aws_route_table.dove-priv-RT.id
}

