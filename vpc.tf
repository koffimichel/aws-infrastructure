resource "aws_vpc" "vpc1" {
 cidr_block = "10.10.0.0/16" 
 instance_tenancy = "default"
 tags = {
    Name = "utc-vpc"
    env = "dev"
    Team = "config management"
 }
}
resource "aws_internet_gateway" "gwy1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "utc-internet-gateway"
    env  = "dev"
    team = "config management"
  }
}

# public subnet
resource "aws_subnet" "public1" {
    availability_zone = "us-east-1a"
    cidr_block = "10.10.1.0/24"
    map_public_ip_on_launch = true
    vpc_id = aws_vpc.vpc1.id
    tags={
        Name = "public-subnet-1"
        env = "dev"
    }
  
}
resource "aws_subnet" "public2" {
    availability_zone = "us-east-1b"
    cidr_block = "10.10.2.0/24"
    vpc_id = aws_vpc.vpc1.id
    map_public_ip_on_launch = true
    tags={
        Name = "public-subnet-2"
        env = "dev"
    }
  
}

resource "aws_subnet" "public3" {
    availability_zone = "us-east-1c"
    cidr_block = "10.10.3.0/24"
    vpc_id = aws_vpc.vpc1.id
    map_public_ip_on_launch = true
    tags={
        Name = "public-subnet-2"
        env = "dev"
    }
  
}
#Private subnet

resource "aws_subnet" "private1" {
    availability_zone = "us-east-1a"
    cidr_block = "10.10.4.0/24"
    vpc_id = aws_vpc.vpc1.id
    tags={
        Name = "private-subnet-1"
        env = "dev"
    } 
}
resource "aws_subnet" "private2" {
    availability_zone = "us-east-1b"
    cidr_block = "10.10.5.0/24"
    vpc_id = aws_vpc.vpc1.id
    tags={
        Name = "private-subnet-2"
        env = "dev"
    }
  
}
resource "aws_subnet" "private3" {
    availability_zone = "us-east-1c"
    cidr_block = "10.10.6.0/24"
    vpc_id = aws_vpc.vpc1.id
    tags={
        Name = "private-subnet-1"
        env = "dev"
    } 
}

#Elastic ip and Nat gateway
resource "aws_eip" "eip" {
  
}
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public1.id
}
resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public1.id
}
#Public route table

resource "aws_route_table" "rtpublic" {
 vpc_id = aws_vpc.vpc1.id 
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gwy1.id
 }
}

#Private route

resource "aws_route_table" "rtprivate" {
 vpc_id = aws_vpc.vpc1.id 
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
 }
}

## Subnet association

resource "aws_route_table_association" "rta1" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.rtprivate.id
}
resource "aws_route_table_association" "rta2" {
  subnet_id = aws_subnet.private2.id
  route_table_id = aws_route_table.rtprivate.id
}

resource "aws_route_table_association" "rta3" {
  subnet_id = aws_subnet.private3.id
  route_table_id = aws_route_table.rtprivate.id
}
resource "aws_route_table_association" "rta4" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.rtpublic.id
}

resource "aws_route_table_association" "rta5" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.rtpublic.id
}
resource "aws_route_table_association" "rta6" {
  subnet_id = aws_subnet.public3.id
  route_table_id = aws_route_table.rtpublic.id
}
