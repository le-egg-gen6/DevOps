terraform {
  	required_providers {
    	aws = {
      		source  = "hashicorp/aws"
      		version = "~> 4.0"
    	}
  	}
}

provider "aws" {
	region = "us-east-1"
}

resource "aws_vpc" "vpc" {
	cidr_block = var.vpc_cidr_block
	enable_dns_hostnames = true

	tags = {
		"Name" = "custom_vpc"
	}
}

# resource "aws_subnet" "privat_subnet_1a" {
# 	vpc_id = aws_vpc.vpc.id
# 	cidr_block = "10.0.1.0/24"
# 	availability_zone = "us-east-1a"

# 	tags = {
# 		"Name" = "privat_subnet_1a"
# 	}
# }

# resource "aws_subnet" "privat_subnet_1b" {
# 	vpc_id = aws_vpc.vpc.id
# 	cidr_block = "10.0.2.0/24"
# 	availability_zone = "us-east-1b"

# 	tags = {
# 		"Name" = "privat_subnet_1b"
# 	}
# }

# resource "aws_subnet" "public_subnet_1c" {
# 	vpc_id = aws_vpc.vpc.id
# 	cidr_block = "10.0.3.0/24"
# 	availability_zone = "us-east-1c"

# 	tags = {
# 		"Name" = "public_subnet_1c"
# 	}
# }

resource "aws_subnet" "private_subnet" {
	count = length(var.private_subnet)
	vpc_id = aws_vpc.vpc.id
	cidr_block = var.private_subnet[count.index]
	availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

	tags = {
		"Name" = "privat_subnet_${var.private_subnet[count.index]}_${var.availability_zones[count.index % length(var.availability_zones)]}"
	}
}

resource "aws_subnet" "public_subnet" {
	count = length(var.public_subnet)
	vpc_id = aws_vpc.vpc.id
	cidr_block = var.public_subnet[count.index]
	availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

	tags = {
		"Name" = "public_subnet_${var.private_subnet[count.index]}_${var.availability_zones[count.index % length(var.availability_zones)]}"
	}
}

resource "aws_internet_gateway" "ig" {
	vpc_id = aws_vpc.vpc.id

	tags = {
		"Name" = "ig"
	}
}

resource "aws_route_table" "rt_public" {
	vpc_id = aws_vpc.vpc.id

	route = {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.ig.id
	}

	tags = {
		"Name" = "rt_public"
	}
}

resource "aws_route_table_association" "public_association" {
	for_each = {for k, v in aws_subnet.public_subnet : k => v}

	subnet_id = each.value.id
	route_table_id = aws_route_table.rt_public.id	
}

resource "aws_eip" "nat_eip" {
	vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
	depends_on = [ aws_internet_gateway.ig ]

	allocation_id = aws_eip.nat_eip.id
	subnet_id = aws_subnet.public_subnet[0].id

	tags = {
		"Name" = "nat_gateway"
	}
}

resource "aws_route_table" "rt_private" {
	vpc_id = aws_vpc.vpc.id

	route = {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.nat_gateway.id
	}

	tags = {	
		"Name" = "rt_private"
	}
}

resource "aws_route_table_association" "private_association" {
	for_each = {for k, v in aws_subnet.private_subnet : k => v}

	subnet_id = each.value.id
	route_table_id = aws_route_table.rt_private.id
}