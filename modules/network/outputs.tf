output "subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.subnet.id
}

output "location" {
  description = "the location of the vnet"
  value = var.location
}

output "resourceGroup" {
  description = "the resource group name"
  value = var.resourceGroup

}