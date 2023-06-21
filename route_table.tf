resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.krowten.id
  tags = {
    Project = "krowten"
  }
}

resource "aws_route" "name" {
  route_table_id = aws_route_table.public-route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}