####################################################################################################
# Internet VPC
####################################################################################################
# SubTask-2
resource "aws_vpc" "main" {
  cidr_block           = var.CIDR_BLOCK["vpc"]
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "assignment-main-vpc"
  }
}

####################################################################################################
# Public subnet 1
####################################################################################################
# SubTask-2
resource "aws_subnet" "main-public-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.CIDR_BLOCK["subnet_public_one"]
  map_public_ip_on_launch = "true"
  availability_zone       = var.AWS_REGION_AZ["a"]
  tags = {
    Name = "subnet-main-public-1"
  }
}

####################################################################################################
# Public subnet 2
####################################################################################################
# SubTask-2
resource "aws_subnet" "main-public-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.CIDR_BLOCK["subnet_public_two"]
  map_public_ip_on_launch = "true"
  availability_zone       = var.AWS_REGION_AZ["b"]
  tags = {
    Name = "subnet-main-public-2"
  }
}

####################################################################################################
# Private subnet 1
####################################################################################################
# SubTask-2
resource "aws_subnet" "main-private-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.CIDR_BLOCK["subnet_private_one"]
  map_public_ip_on_launch = "false"
  availability_zone       = var.AWS_REGION_AZ["a"]
  tags = {
    Name = "subnet-main-private-1"
  }
}

####################################################################################################
# Public subnet 2
####################################################################################################
# SubTask-2
resource "aws_subnet" "main-private-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.CIDR_BLOCK["subnet_private_two"]
  map_public_ip_on_launch = "false"
  availability_zone       = var.AWS_REGION_AZ["b"]
  tags = {
    Name = "subnet-main-private-2"
  }
}

####################################################################################################
# Internet GW
####################################################################################################
# SubTask-2
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "assignment-main-gw"
  }
}

####################################################################################################
# Route Table
####################################################################################################
# SubTask-2
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }
}

####################################################################################################
# Route Associations  - public
####################################################################################################
# SubTask-2
resource "aws_route_table_association" "main-public-1-a" {
  subnet_id      = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.main-public.id
}

resource "aws_route_table_association" "main-public-2-a" {
  subnet_id      = aws_subnet.main-public-2.id
  route_table_id = aws_route_table.main-public.id
}



####################################################################################################
# NAT Gateway assocaited 
####################################################################################################
# SubTask-2
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main-public-1.id
  depends_on    = [aws_internet_gateway.main-gw]
}

resource "aws_route_table" "main-private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }
}

####################################################################################################
# Route Associations  - private
####################################################################################################
# SubTask-2
resource "aws_route_table_association" "main-private-1-a" {
  subnet_id      = aws_subnet.main-private-1.id
  route_table_id = aws_route_table.main-private.id
}

resource "aws_route_table_association" "main-private-2-a" {
  subnet_id      = aws_subnet.main-private-2.id
  route_table_id = aws_route_table.main-private.id
}
