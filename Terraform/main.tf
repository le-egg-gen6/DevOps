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

module "vpc" {
    source = "vpc"

    vpc_cidr_block = "10.0.0.0/16"
    private_subnet = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
    public_subnet = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
    availability_zones = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}