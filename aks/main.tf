module "aks" {
  source = "Azure/aks/azurerm"
  version = "latest"

  // Add your configuration here
  resource_group_name = "mks"
  client_id           = var.client_id
  client_secret       = var.client_secret
  prefix = "MKS"
  location = "west-europe"

  // ... other variables
}
