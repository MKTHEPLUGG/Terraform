resource "azurerm_resource_group" "myRG" {
  name     = "vnet-test-rg-tf-1"
  location = "westeurope"
}

module "virtual_network" {
  source              = "./modules"
  vnet_name           = "vnet-32"
  resource_group_name = azurerm_resource_group.myRG.name
  location            = azurerm_resource_group.myRG.location
  vnet_address_space  = ["10.0.0.0/16"]
  subnets = [
    {
      name             = "subnet1"
      address_prefixes = ["10.0.1.0/24"]
    },
    {
      name              = "subnet2"
      address_prefixes  = ["10.0.2.0/24"]
      service_endpoints = ["Microsoft.Sql"]
    },
    {
      name              = "subnet3"
      address_prefixes  = ["10.0.3.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Web"]
    }
  ]
}