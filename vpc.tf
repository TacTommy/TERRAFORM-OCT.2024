resource "aws_vpc" "TI-GROUP-VPC" {
  cidr_block         = "10.0.0.0/16"
  instance_tenancy   = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "TENACITY-GROUP"
  }
}
resource "aws_subnet" "Prod-pub-sub1" {
  vpc_id     = aws_vpc.TI-GROUP-VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Prod-pub-sub1"
  }
}

resource "aws_subnet" "Prod-pub-sub2" {
  vpc_id     = aws_vpc.TI-GROUP-VPC.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Prod-pub-sub2"
  }
}

resource "aws_subnet" "Prod-priv-sub1" {
  vpc_id     = aws_vpc.TI-GROUP-VPC.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Prod-priv-sub1"
  }
}

resource "aws_subnet" "Prod-priv-sub2" {
  vpc_id     = aws_vpc.TI-GROUP-VPC.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Prod-priv-sub2"
  }
}

resource "aws_route_table" "Prod-pub-route-table" {
  vpc_id = aws_vpc.TI-GROUP-VPC.id

  tags = {
    Name = "Prod-pub-route-table"
  }
}

resource "aws_route_table" "Prod-priv-route-table" {
  vpc_id = aws_vpc.TI-GROUP-VPC.id

  tags = {
    Name = "Prod-priv-route-table"
  }
}
resource "aws_route_table_association" "public-route-1-association" {
  subnet_id      = aws_subnet.Prod-pub-sub1.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}

resource "aws_route_table_association" "public-route-2-association" {
  subnet_id      = aws_subnet.Prod-pub-sub2.id
  route_table_id = aws_route_table.Prod-pub-route-table.id
}

resource "aws_route_table_association" "private-route-1-association" {
  subnet_id      = aws_subnet.Prod-priv-sub1.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}

resource "aws_route_table_association" "private-route-2-association" {
  subnet_id      = aws_subnet.Prod-priv-sub2.id
  route_table_id = aws_route_table.Prod-priv-route-table.id
}

resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.TI-GROUP-VPC.id

  tags = {
    Name = "Prod-igw"
  }
}

resource "aws_route" "Prod-igw-association" {
  route_table_id            = aws_route_table.Prod-pub-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.Prod-igw.id
}

resource "aws_nat_gateway" "Prod-Nat-Gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.Prod-pub-sub1.id
}

resource "aws_route" "Prod-Nat-association" {
  route_table_id            = aws_route_table.Prod-priv-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_nat_gateway.Prod-Nat-Gateway.id
}