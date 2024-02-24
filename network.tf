module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.2.0"

  create_vpc = true
  name       = local.name
  cidr       = local.vpc_cidr

  azs = local.azs
  private_subnets = [
    local.cidr_blocks["public_subnet_1"],
    local.cidr_blocks["public_subnet_2"],
    local.cidr_blocks["public_subnet_3"]
  ]
  public_subnets = [
    local.cidr_blocks["private_subnet_1"],
    local.cidr_blocks["private_subnet_2"],
    local.cidr_blocks["private_subnet_3"]
  ]
  create_database_subnet_group  = false
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.0"

  vpc_id = module.vpc.vpc_id

  endpoints = { for service in toset(["ssm", "ssmmessages", "ec2messages"]) :
    replace(service, ".", "_") =>
    {
      service             = service
      subnet_ids          = module.vpc.private_subnets
      private_dns_enabled = true
      tags                = { Name = "${local.name}-${service}" }
    }
  }

  create_security_group      = true
  security_group_name_prefix = "${local.name}-vpc-endpoints-"
  security_group_description = "VPC endpoint security group"
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from subnets"
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }
}
