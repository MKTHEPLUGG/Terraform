resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${local.resource_name}-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_DS1_v2"
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    name              = "${local.resource_name}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  admin_username = "adminuser"
  admin_password = data.azurerm_key_vault_secret.vm_password.value

  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19.04"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.bootdiagstorage.primary_blob_endpoint
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${local.resource_name}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "${local.resource_name}-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

locals {
  resource_name = "${var.resource_prefix}-resource"
}

resource "azurerm_storage_account" "bootdiagstorage" {
  name                     = "${lower(var.resource_prefix)}bootstore"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = var.secret_name
  key_vault_id = var.key_vault_id
  depends_on   = [module.keyvault_and_key.secret_id]
}

module "keyvault_and_key" {
  source = "../keyvault_and_key"
  # ... other module inputs ...
}