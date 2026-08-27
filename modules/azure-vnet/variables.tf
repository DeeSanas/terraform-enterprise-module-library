variable "name" {
  description = "Virtual network name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Existing resource group that will contain the VNet."
  type        = string
}

variable "address_space" {
  description = "VNet address-space CIDRs."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "At least one VNet address-space CIDR is required."
  }
}

variable "subnets" {
  description = "Map of subnet name to CIDR."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
