data "aws_availability_zones" "availabe" {
  
}


locals {
  cluster_name="jaideep-${random_string.suffix.result}"

}


resource "random_string" "suffix" {

    length = 8
    special = false

  
}
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.7.0"
    name = "My-vpc"
    cidr = var.cidr_range
    azs = data.aws_availability_zones.availabe.names
    private_subnets =["10.0.1.0/24","10.0.2.0/24"]
    public_subnets = ["10.0.4.0/24","10.0.5.0/24"]

    enable_vpn_gateway = true
    enable_nat_gateway = true
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        "kubernets.io/cluster/${local.cluster_name}"="shared"
    }

    public_subnet_tags = {
        "kubernets.io/cluster/${local.cluster_name}"="shared"
        "kubernets.io/role/elb"="1"
    }

    private_subnet_tags = {

        "kubernets.io/cluster/${local.cluster_name}"="shared"
        "kubernets.io/role/internal-elb"="1"

    }
}
