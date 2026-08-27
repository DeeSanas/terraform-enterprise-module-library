output "vnet_id" {
  description = "Virtual network identifier."
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "Map of subnet IDs keyed by subnet name."
  value       = { for name, subnet in azurerm_subnet.this : name => subnet.id }
}
