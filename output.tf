# output "az_names" {
#     value = data.aws_availability_zones.available
# }

# output "subnet_info" {
#     value = aws_subnet.public
# }

output "vpc_id" {
    value = aws_vpc.main.id
  
}