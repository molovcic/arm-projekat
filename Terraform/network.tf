resource "aws_vpc" "arm_vpc" {
 cidr_block = var.vpc_cidr
 enable_dns_hostnames = true
}
resource "aws_subnet" "arm_subnet_private" {
 vpc_id = aws_vpc.arm_vpc.id
 cidr_block = var.private_subnet
 tags = {
 "Name" = "armz19378-Private"
 }
}
resource "aws_subnet" "arm_subnet_public" {
 vpc_id = aws_vpc.arm_vpc.id
 cidr_block = var.public_subnet
 map_public_ip_on_launch = true
 tags = {
 "Name" = "armz19378-Public"
 }
}
resource "aws_internet_gateway" "arm_igw" {
 vpc_id = aws_vpc.arm_vpc.id
}
resource "aws_route_table" "arm_public_rt" {
 vpc_id = aws_vpc.arm_vpc.id
 route {
 cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.arm_igw.id
 }
}
resource "aws_route_table_association" "arm_rt_public_subnet" {
 subnet_id = aws_subnet.arm_subnet_public.id
 route_table_id = aws_route_table.arm_public_rt.id
}
resource "aws_eip" "arm_eip" {
 vpc = true
}
resource "aws_nat_gateway" "arm_nat_gateway" {
 allocation_id = aws_eip.arm_eip.id
 subnet_id = aws_subnet.arm_subnet_public.id
 depends_on = [
 aws_internet_gateway.arm_igw
 ]
}
resource "aws_route_table" "arm_private_rt" {
 vpc_id = aws_vpc.arm_vpc.id
 route {
 cidr_block = "0.0.0.0/0"
 nat_gateway_id = aws_nat_gateway.arm_nat_gateway.id
 }
}
resource "aws_route_table_association" "arm_rt_private_subnet" {
 subnet_id = aws_subnet.arm_subnet_private.id
 route_table_id = aws_route_table.arm_private_rt.id
}
resource "aws_security_group" "arm_security_group" {
 name = "arm_security_group"
 description = "Security group for ARM EC2 instance"
 vpc_id = aws_vpc.arm_vpc.id
 ingress {
 from_port = 22
 to_port = 22
 protocol = 6 # TCP
 cidr_blocks = ["0.0.0.0/0"]
 description = "Allow SSH ingress"
 }
 ingress {
 from_port = 80
 to_port = 80
 protocol = 6
 cidr_blocks = ["0.0.0.0/0"]
 description = "Allow HTTP ingress"
 }
 ingress {
 from_port = 443
 to_port = 443
 protocol = 6
 cidr_blocks = ["0.0.0.0/0"]
 description = "Allow HTTPS ingress"
 }
 ingress {
 from_port = 0
 to_port = 0
 protocol = -1
 self = true
 description = "Allow traffic in security group"
 }
 egress {
 from_port = 80
 to_port = 80
 protocol = 6
 cidr_blocks = ["0.0.0.0/0"]
 description = "Allow HTTP egress"
 }
 egress {
 from_port = 443
 to_port = 443
 protocol = 6
 cidr_blocks = ["0.0.0.0/0"]
 description = "Allow HTTPS egress"
 }
 egress {
 from_port = 0
 to_port = 0
 protocol = -1
 self = true
 description = "Allow traffic in security group"
 }
}
