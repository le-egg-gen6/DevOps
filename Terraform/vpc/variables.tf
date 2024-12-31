variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
}

variable "private_subnet" {
    type = list(string)
    default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}

variable "public_subnet" {
    type = list(string)
    default = [ "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
}

variable "availability_zones" {
    type = list(string)
    default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}