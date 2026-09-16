locals {
  azs = slice([data.aws_availability_zones.aws_availability_zones.name], 0, 3 )

    #   public_subnets = cidrsubnet("10.0.0.0/16", 8, 0)
    #   private_subnets = cidrsubnet("10.0.0.0/16", 8, 0+10)

  public_subnets  = [for k, az in locals.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k)]
  private_subnets = [for k, az in locals.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k+10 )]

}


