terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
      }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "main"
    }
}

resource "aws_subnet" "public01" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "public-subnet01"
    }
}

resource "aws_subnet" "public02" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "public-subnet02"
    }
}
  
resource "aws_subnet" "private01" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = false
    tags = {
        Name = "private-subnet01"
    }
}

resource "aws_subnet" "private02" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false
    tags = {
        Name = "private-subnet02"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "main-igw"
    }
}

resource "aws_eip" "nat01" {
#     domain = "vpc"  
}

resource "aws_eip" "nat02" {
#     domain = "vpc"  
}

resource "aws_nat_gateway" "main01" {
    allocation_id = aws_eip.nat01.id
    subnet_id = aws_subnet.public01.id
    tags = {
        Name = "main-natgw01"
    }
}

resource "aws_nat_gateway" "main02" {
    allocation_id = aws_eip.nat02.id
    subnet_id = aws_subnet.public02.id
    tags = {
        Name = "main-natgw02"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "public-rt"
    }
}

resource "aws_route_table" "private01" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main01.id
    }
    tags = {
        Name = "private-rt01"
    }
}

resource "aws_route_table" "private02" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main02.id
    }
    tags = {
        Name = "private-rt02"
    }
}

resource "aws_route_table_association" "public01" {
    subnet_id = aws_subnet.public01.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private01" {
    subnet_id = aws_subnet.private01.id
    route_table_id = aws_route_table.private01.id
}

resource "aws_route_table_association" "public02" {
    subnet_id = aws_subnet.public02.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private02" {
    subnet_id = aws_subnet.private02.id
    route_table_id = aws_route_table.private02.id
}

resource "aws_security_group" "web" {
    name = "web"
    description = "Allow inbound HTTP traffic"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "web-sg"
    }
}

resource "aws_instance" "Webserver01" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.public01.id
    vpc_security_group_ids = [aws_security_group.web.id]
    associate_public_ip_address = true
    key_name = var.key_pair
    tags = {
        Name = "Webserver01"
    }
}

resource "aws_instance" "Webserver02" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.public02.id
    vpc_security_group_ids = [aws_security_group.web.id]
    associate_public_ip_address = true
    key_name = var.key_pair
    tags = {
        Name = "Webserver02"
    }
}