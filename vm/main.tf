module "network" {
  source = "../modules/network"

  resource_prefix = "test123"  # Provide necessary variable values here
  location        = "westeurope"
  resourceGroup = "test-tf-3"
}


module "keyvault" {
  source = "../modules/keyvault_and_key"

  location        = module.network.location
  rgName = module.network.resourceGroup
}

module "vm" {
  source = "../modules/vm"
  
  resource_group_name = "test-tf-3"
  resource_prefix   = var.resource_prefix

  secret_name  = module.keyvault.secret_name
  key_vault_id = module.keyvault.key_vault_id
  secret_id  = module.keyvault.secret_id
  key_vault_key_uri = module.keyvault.key_vault_key_uri
  key_name = module.keyvault.key_name
  subnet_id         = module.network.subnet_id

  }
