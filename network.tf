module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = local.name
  cidr = local.vpc_cidr

  azs                          = local.azs
  private_subnets              = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets               = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + length(local.azs))]
  create_database_subnet_group = false
  manage_default_network_acl   = false
  manage_default_route_table   = false
  manage_default_security_group = false

  enable_nat_gateway = true
  single_nat_gateway = false
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
