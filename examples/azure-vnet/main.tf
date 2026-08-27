terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-platform-dev"
  location = "eastus"
}

module "network" {
  source = "../../modules/azure-vnet"

  name                = "vnet-platform-dev"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.30.0.0/16"]

  subnets = {
    app  = "10.30.10.0/24"
    data = "10.30.20.0/24"
  }

  tags = {
    environment = "dev"
    managed_by  = "terraform"
    owner       = "platform"
  }
}

output "vnet_id" {
  value = module.network.vnet_id
}
