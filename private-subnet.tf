resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.16/28"
  availability_zone = "us-east-2b"

  tags = {
    Name = "PrivateSubnet"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.32/28"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Private2Subnet"
  }
}

resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id    
  }

  tags = {
    Name = "terraformPrivateRT"
  }
}


resource "aws_route_table_association" "private_sub_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.PrivateRT.id
}


