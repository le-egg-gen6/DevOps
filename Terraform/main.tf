terraform {
  	required_providers {
    	aws = {
      		source  = "hashicorp/aws"
      		version = "~> 4.0"
    	}
  	}
}

variable "ec2_instance_type" {
    type        = string
    description = "Instance type of EC2"
    default     = "t2.micro"
}

provider "aws" {
    region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  	most_recent = true
  	owners      = ["099720109477"]

  	filter {
    	name   = "name"
    	values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  	}
}

resource "aws_instance" "ec2" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = var.ec2_instance_type
    tags = {
        Name = "HelloWorld"
    }
}

output "ec2_public_ip" {
	value = aws_instance.ec2.public_ip
}
