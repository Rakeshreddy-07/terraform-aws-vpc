variable "cidr_block" {
  
}

variable "environment" {
  
}

variable "project" {
  
}

variable "common_tags" {
    type = map 
    
}

variable "vpc_tags" {
    default = {}
  
}

variable "dns_hostnames" {
    default = "true"
  
}

variable "igw_tags" {
    default = {

    }
  
}

variable "public_subnet_cidr" {

  validation {
    condition     = length(var.public_subnet_cidr) == 2
    error_message = "Please provide two CIDR ranges for public subnet"
  }
} 

variable "public_subnet_tags" {
    default = {

    }
  
}

variable "private_subnet_cidr" {

  validation {
    condition     = length(var.private_subnet_cidr) == 2
    error_message = "Please provide two CIDR ranges for public subnet"
  }
} 

variable "private_subnet_tags" {
    default = {

    }
  
}

variable "database_subnet_cidr" {

  validation {
    condition     = length(var.database_subnet_cidr) == 2
    error_message = "Please provide two CIDR ranges for public subnet"
  }
} 

variable "database_subnet_tags" {
    default = {

    }
  
}

variable "nat_gw_tags" {
    default = {

    }
  
}

variable "public_route_table_tags" {
    default = {

    }
  
}

variable "private_route_table_tags" {
    default = {

    }
  
}

variable "database_route_table_tags" {
    default = {

    }
  
}

variable "is_peering_required" {
    default = false
  
}

variable "vpc_peering_tags" {
    default = {}
  
}