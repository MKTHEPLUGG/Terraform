resource "azurerm_resource_group" "rg" {
  name     = "app-rg-ex3"
  location = var.location
}

module "keyvault_and_key" {
  source = "./modules/keyvault_and_key"
  # ... other module inputs ...
}



module "network" {
  source = "./modules/network"

}

module "vm" {
  source = "./modules/vm"

  secret_name  = module.keyvault_and_key.secret_name
  key_vault_id = module.keyvault_and_key.key_vault_id
  secret_id  = module.keyvault_and_key.secret_id
  key_vault_key_uri = module.keyvault_and_key.key_vault_key_uri
  key_name = module.keyvault_and_key.key_name
  resource_prefix   = var.resource_prefix
  subnet_id         = module.network.subnet_id

}

locals {
  resource_name = "${var.resource_prefix}-resource"
}


