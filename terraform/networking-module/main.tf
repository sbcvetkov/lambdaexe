provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "default" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_default_route_table" "lambaexe_routes" {
  default_route_table_id = aws_vpc.default.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_security_group" "postgres_sg" {
  name        = "postgres_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    description = "Allow Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/32"]
  }
}

resource "aws_subnet" "lambdaexe_subnet_1" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.subnet1_cidr
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "lambdaexe_subnet_2" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.subnet2_cidr
  availability_zone = "eu-central-1b"
}

resource "aws_db_subnet_group" "lambdaexe_db_subnet_group" {
  name        = "lambdaexe_db_subnet_group"
  description = "Our main group of subnets"
  subnet_ids  = [aws_subnet.lambdaexe_subnet_1.id, aws_subnet.lambdaexe_subnet_2.id]
}
