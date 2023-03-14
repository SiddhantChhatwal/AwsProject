resource "aws_vpc" "app-vpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = "true"    
  tags = {
    Name = "app-vpc"
  }
}

resource "aws_internet_gateway" "app-igw" {
  vpc_id = aws_vpc.app-vpc.id
  tags = {
    Name = "app-igw"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id = aws_vpc.app-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id = aws_vpc.app-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_route_table" "public-routetable" {
  vpc_id = aws_vpc.app-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app-igw.id
  }
  tags = {
    Name = "public-routetable"
  }
}

resource "aws_route_table_association" "public-subnet-1-association" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-routetable.id
}

resource "aws_route_table_association" "public-subnet-2-association" {
  subnet_id = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-routetable.id
}
