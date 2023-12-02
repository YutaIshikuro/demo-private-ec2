module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  # private
  name          = "${local.name}-instance"
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  availability_zone      = local.azs[0]
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.security_group_instance.security_group_id]

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
    }
  ]

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    SSMStartSession = aws_iam_policy.ssm_document.arn
  }
}

module "ec2_instance_01" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  # private
  name          = "${local.name}-instance-01"
  ami           = data.aws_ami.amazonlinux_2023.id
  instance_type = "t2.micro"

  availability_zone      = local.azs[0]
  subnet_id              = element(module.vpc.private_subnets, 0)
  vpc_security_group_ids = [module.security_group_instance.security_group_id]

  user_data = file("user_data.sh")

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
    }
  ]

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    SSMStartSession = aws_iam_policy.ssm_document.arn
  }
}

module "security_group_instance" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${local.name}-ec2"
  description = "Security Group for EC2 Instance Egress"

  vpc_id = module.vpc.vpc_id

  egress_rules = ["https-443-tcp"]
}

resource "aws_iam_policy" "ssm_document" {
  name        = "ssc-start-session"
  path        = "/"
  description = "ssm start session policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:StartSession",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ec2:${local.region}:${data.aws_caller_identity.current.account_id}:instance/*",
          "arn:aws:ssm:*:*:document/AWS-StartSSHSession"
        ]
      },
    ]
  })
}