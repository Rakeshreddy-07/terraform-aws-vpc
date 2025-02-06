data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_route_table" "default" {
  vpc_id = local.default_vpc
  filter {
    name = "association.main"
    values = ["true"]
  }
}
