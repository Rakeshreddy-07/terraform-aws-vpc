resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
    enable_dns_hostnames = true


  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = local.resource_name
    }
  )
}
