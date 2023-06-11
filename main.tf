terraform {
  
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "4.5.0"
      }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
}



resource "aws_vpc" "ecommerce-vpc" {
  cidr_block = "${var.vpcCidr}"
}


resource "aws_subnet" "subnet_1a" {
  vpc_id     = aws_vpc.ecommerce-vpc.id
  cidr_block = "${var.subnet1aCidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "subnet-1a"
  }
}


resource "aws_subnet" "subnet_1b" {
  vpc_id     = aws_vpc.ecommerce-vpc.id
  cidr_block = "${var.subnet1bCidr}"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "subnet-1b"
  }
}




resource "aws_subnet" "subnet_1c" {
  vpc_id     = aws_vpc.ecommerce-vpc.id
  cidr_block = "${var.subnet1cCidr}"
  availability_zone = "us-east-1c"
  tags = {
    Name = "subnet-1c"
  }
}


resource "aws_internet_gateway" "myvpc_ig" {
  vpc_id = aws_vpc.ecommerce-vpc.id

  tags = {
    Name = "myvpc_ig"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.ecommerce-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myvpc_ig.id
  }

  tags = {
    Name = "rt_public"
  }
}

resource "aws_route_table_association" "associate-1a-rt" {
  subnet_id      = aws_subnet.subnet_1a.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "associate-1b-rt" {
  subnet_id      = aws_subnet.subnet_1b.id
  route_table_id = aws_route_table.rt_public.id
}



resource "aws_instance" "app_server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  key_name      = "advdevops3004"
  security_groups = [ aws_security_group.allow_http.name ]
  tags = {
    Name = "Machine1FromTerraform"
    Type = "AppServer"
    Webserver = "Nginx"
    managed-by = "Terraform"
  }
}


resource "aws_security_group" "allow_http" {
  name="allow_http"
  description = "Allow http inbound traffic"
  ingress {
    description      = "HTTP fnginx webserver"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "webservers" {
  name        = "webservers-80"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.ecommerce-vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }

  ingress {
    description      = "SSH server"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "allow_http"
  }
}

