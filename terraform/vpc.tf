terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

#creating vpc

resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}

#creating subnet

resource "aws_subnet" "subnet-a" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-a"
  }
}

#creating igw

resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
}

#creating route table

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.dev-vpc.id
}

#creating route for igw

resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev-igw.id
}

#associate route to subnet

resource "aws_route_table_association" "subnet-associate" {
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.subnet-a.id
}


#create security group

resource "aws_security_group" "dev-sg" {
  name        = "dev-sg"
  description = "dev vpc security group"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "allow 22 port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow 80 port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
