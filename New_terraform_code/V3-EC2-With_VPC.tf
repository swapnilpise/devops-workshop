provider "aws" {
    region = "us-east-1"

}

resource "aws_instance" "demo-server" {
    ami = "ami-06b21ccaeff8cd686"
    instance_type = "t2.micro"
    key_name = "ddp"
    //security_groups = [ "demo-sg" ]
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.dpp-public-subnet-01.id
    }
     
    resource "aws_security_group" "demo-sg" {
        name = "demo-sg"
        description = "ssh Access"
        vpc_id = aws_vpc.dpp-vpc.id

        ingress {
            description = "ssh Access"
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = [ "0.0.0.0/0" ]

        }

        egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = [ "0.0.0.0/0" ]
            ipv6_cidr_blocks = [ "::/0" ]
        }     

        tags = {
          Name = "ssh-port"
        }
    }

//create vpc
resource "aws_vpc" "dpp-vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
        Name = "dpp-vpc"
    }  
}

//create subnet
resource "aws_subnet" "dpp-public-subnet-01" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
        Name = "dpp-public-subnet-01"
    }
}
//create anather subnet
resource "aws_subnet" "dpp-public-subnet-02" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
        Name = "dpp-public-subnet-02"
    }
}
//create internet gateway
resource "aws_internet_gateway" "dpp-igw" {
    vpc_id = aws_vpc.dpp-vpc.id
    tags = {
      Name = "dpp-igw"
      }
    }
  
//create route table
resource "aws_route_table" "dpp-public-rt" {
    vpc_id = aws_vpc.dpp-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dpp-igw.id
    }
}

//create route table association add subnet-01
resource "aws_route_table_association" "dpp-rta-public-subnet-01" {
    subnet_id = aws_subnet.dpp-public-subnet-01.id
    route_table_id = aws_route_table.dpp-public-rt.id
}

//add subnet-2
resource "aws_route_table_association" "dpp-rta-public-subnet-02" {
    subnet_id = aws_subnet.dpp-public-subnet-02.id
    route_table_id = aws_route_table.dpp-public-rt.id
    }