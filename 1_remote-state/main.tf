provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tfstate_rg" {
  name     = "TerraformStateRG"
  location = "West Europe"
}

resource "azurerm_storage_account" "tfstate_sa" {
  name                     = "tfstatestore12345" # Ensure this is unique across Azure
  resource_group_name      = azurerm_resource_group.tfstate_rg.name
  location                 = azurerm_resource_group.tfstate_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = "tfstatecontainer"
  storage_account_name  = azurerm_storage_account.tfstate_sa.name
  container_access_type = "private"
}
