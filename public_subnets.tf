resource "aws_subnet" "public-us-east-1d" {
  vpc_id = aws_vpc.krowten.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1d"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-us-east-1d"
    Project = "krowten"
  }
}
resource "aws_route_table_association" "connect-public-us-east-1d-to-internet" {
  route_table_id = aws_route_table.public-route.id
  subnet_id = aws_subnet.public-us-east-1d.id
}

resource "aws_subnet" "public-us-east-1e" {
  vpc_id = aws_vpc.krowten.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-east-1e"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-us-east-1e"
    Project = "krowten"
  }
}
resource "aws_route_table_association" "connect-public-us-east-1e-to-internet" {
  route_table_id = aws_route_table.public-route.id
  subnet_id = aws_subnet.public-us-east-1e.id
}

resource "aws_subnet" "public-us-east-1f" {
  vpc_id = aws_vpc.krowten.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-east-1f"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-us-east-1f"
    Project = "krowten"
  }
}
resource "aws_route_table_association" "connect-public-us-east-1f-to-internet" {
  route_table_id = aws_route_table.public-route.id
  subnet_id = aws_subnet.public-us-east-1f.id
}
