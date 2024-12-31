# AWS Region
variable "aws_region" {
  description = "AWS region"
  type        = string
}

# VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Subnet CIDR
variable "subnet_cidr" {
  description = "CIDR block for the Subnet"
  type        = string
}

# AMI ID for EC2
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

# EC2 Instance Type
variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

# Key Pair Name
variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}
