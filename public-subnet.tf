resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.0/28"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.48/28"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-2Subnet"
  }
}

resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "terraformIGW"
  }
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw.id
  }

  tags = {
    Name = "terraformPRT"
  }
}


resource "aws_route_table_association" "pub_sub_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.PublicRT.id
  }
resource "aws_route_table_association" "pub_sub_association2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.PublicRT.id
  }  
