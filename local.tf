locals {
  name        = "private-ec2-test"
  region      = "ap-northeast-1"

  vpc_cidr = "172.16.0.0/16"
  cidr_blocks = {
    public_subnet_1  = cidrsubnet(local.vpc_cidr, 8, 0)
    public_subnet_2  = cidrsubnet(local.vpc_cidr, 8, 1)
    public_subnet_3  = cidrsubnet(local.vpc_cidr, 8, 2)
    private_subnet_1 = cidrsubnet(local.vpc_cidr, 8, 3)
    private_subnet_2 = cidrsubnet(local.vpc_cidr, 8, 4)
    private_subnet_3 = cidrsubnet(local.vpc_cidr, 8, 5)
  }
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}