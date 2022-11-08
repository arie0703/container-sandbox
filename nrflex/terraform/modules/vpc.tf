module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "3.10.0"

    name = "ecs-newrelic"
    cidr                 = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true

    azs             = ["ap-northeast-1a", "ap-northeast-1c"]
    public_subnets  = ["10.0.11.0/24", "10.0.12.0/24"]

    manage_default_security_group  = true
    default_security_group_ingress = []
    default_security_group_egress  = []
}
