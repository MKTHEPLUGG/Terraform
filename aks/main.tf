module "aks" {
  source = "Azure/aks/azurerm"
  version = "7.4.0"

  // Add your configuration here
  resource_group_name = "mks"
  client_id           = var.client_id
  client_secret       = var.client_secret
  prefix = "MKS"
  location = "West Europe"

  // ... other variables
  // https://github.com/Azure/terraform-azurerm-aks/blob/main/variables.tf
  // https://registry.terraform.io/modules/Azure/aks/azurerm/latest 
  //
  // if we don't want to use the module we can use the resource azurerm_kubernetes_cluster
  // https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster
  // 
  //
}
