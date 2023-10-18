output "resource_group_name" {
  value = azurerm_resource_group.SymbolicRG.name
}

output "azurerm_key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "azurerm_key_vault_id" {
  value = azurerm_key_vault.kv.id
}

output "key_vault_key_uri" {
  value = azurerm_key_vault_secret.kv_secret.id
}

output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "key_name" {
  description = "The name of the key/secret in the Key Vault"
  value       = local.key_name
}

output "secret_id" {
  value = azurerm_key_vault_secret.kv_secret.id
}

output "secret_name" {
  value = azurerm_key_vault_secret.kv_secret.name
}