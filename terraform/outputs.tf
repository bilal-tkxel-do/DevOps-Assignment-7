# VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}

# Subnet ID
output "subnet_id" {
  value = aws_subnet.main.id
}

# EC2 Public IP
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

