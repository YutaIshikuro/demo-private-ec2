data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "amazonlinux_2023" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"

    values = [ "al2023-ami-*-kernel-6.1-x86_64" ] # x86_64
    # values = [ "al2023-ami-*-kernel-6.1-arm64" ] # ARM
    # values = [ "al2023-ami-minimal-*-kernel-6.1-x86_64" ] # Minimal Image (x86_64)
    # values = [ "al2023-ami-minimal-*-kernel-6.1-arm64" ] # Minimal Image (ARM)
  }
}