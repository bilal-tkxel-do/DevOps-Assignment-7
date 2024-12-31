provider "aws" {
  region = "us-east-1"
}

# S3 Backend Configuration
terraform {
  backend "s3" {
    bucket  = "terraform-state-bucket-bilal"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Terraform-VPC"
  }
}

#Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "Terraform-Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Terraform-Internet-Gateway"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Terraform-Public-Route-Table"
  }
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "ssh" {
  name_prefix = "ssh-sg-"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH Security Group"
  }
}

resource "aws_key_pair" "terraform_key" {
  key_name   = var.key_name               
  public_key = file("~/.ssh/id_rsa.pub")    
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  key_name      = aws_key_pair.terraform_key.key_name

  # Use vpc_security_group_ids for instances inside a VPC
  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "Terraform-EC2"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "terraform" {
  bucket = "terraform-bucket-test-bilal"

  tags = {
    Name = "Terraform-Bucket-Test"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


