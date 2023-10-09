output "resource_group_name" {
  value = azurerm_resource_group.SymbolicRG.name
}

output "azurerm_key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "azurerm_key_vault_id" {
  value = azurerm_key_vault.kv.id
}