locals {
  name        = "private-ec2-test"
  public_name = "private-ec2-test"
  region      = "ap-northeast-1"

  vpc_cidr = "172.16.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}