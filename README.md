# private-ec2

# Terraform AWS VPC and Private EC2 Example

This repository contains Terraform configurations to create a Virtual Private Cloud (VPC) and launch a private EC2 instance within it using the `terraform-aws-modules` provided modules. This setup is ideal for creating isolated network environments with private instances.

## Prerequisites

Before you begin, ensure you have the following prerequisites:

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS credentials configured. You can set them up using the AWS CLI or environment variables.

## Usage

1. Clone this repository to your local machine:

```bash
git clone git@github.com:YutaIshikuro/private-ec2.git
cd private-ec2
```

2. Initialize the Terraform working directory:
```bash
terraform init
```

3. Plan the Terraform configuration:
```bash
terraform plan
```

4. To destroy the resources created by Terraform and release the associated AWS resources, run:
```bash
terraform destroy
```

### Resources to be created
- IAM Instance Profile
- IAM Role
- EC2 Instance
- SecrityGroup for EC2 Instance
- SecrityGroup for VPC Endpoints
- Nat Gateways
- EIPs for Nats
- InterNet Gateway
- Route Tables for PrivateSubnets
- Route Table for PublicSubnet
- PrivateSubnets
- PublicSubnets
- VPC
- VPC Endpoints
  - ssm
  - ssmmessages
  - ec2messages
