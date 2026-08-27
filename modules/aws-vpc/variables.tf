variable "name" {
  description = "Name prefix for network resources."
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR for the VPC."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "cidr_block must be a valid IPv4 CIDR."
  }
}

variable "availability_zones" {
  description = "Availability zones used to distribute subnets."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be supplied."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public-tier subnets. No automatic public IPv4 assignment is enabled."
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private-tier subnets. NAT/egress is intentionally not created by this module."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags merged onto resources."
  type        = map(string)
  default     = {}
}
