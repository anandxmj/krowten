resource "aws_subnet" "private-us-east-1a" {
  vpc_id = aws_vpc.krowten.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-us-east-1a"
    Project = "krowten"
  }
}

resource "aws_subnet" "private-us-east-1b" {
  vpc_id = aws_vpc.krowten.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-us-east-1b"
    Project = "krowten"
  }
}

resource "aws_subnet" "private-us-east-1c" {
  vpc_id = aws_vpc.krowten.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "private-us-east-1c"
    Project = "krowten"
  }
}