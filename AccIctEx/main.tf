data "azurerm_client_config" "current" {
  // we can use this to import the data from the current client config, don't even need to specify anything here can just use it below in kv resource
}

resource "azurerm_resource_group" "SymbolicRG" {
  // if you want to ignore changes to the infra
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  name     = var.rgName
  location = var.location
  tags = {
    "Env" = "Prod"
  }
}

resource "random_string" "kv_name" {
  length  = 12
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "random_string" "key_name" {
  length  = 12
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "random_password" "user_password" {
  length      = 15
  min_numeric = 3
  min_special = 3
  min_upper   = 3
}


resource "azurerm_key_vault" "kv" {
  // coalesce uses var.vaultname and if there is no name it will create the vault- resource above
  name = coalesce(var.vault_name, "vault-${random_string.kv_name.result}")
  // using azurerm_resource_group.SymbolicRG it will take the location of the resource above
  location            = azurerm_resource_group.SymbolicRG.location
  resource_group_name = azurerm_resource_group.SymbolicRG.name
  // or just get it from a variable like before
  sku_name = var.sku_name
  // here we use the data object created at the top
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true

}

// assign admin role to current az logged in object id
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.kv.id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "key vault administrator"
}

// add a secret to the vault
resource "azurerm_key_vault_key" "kv_key" {
  // locals is like vars in bicep, from locals.tf file we import this value
  name         = local.key_name
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = var.key_type
  key_size     = var.key_size
  key_opts     = var.key_opts

  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }

    expire_after         = "P90D"
    notify_before_expiry = "P29D"
  }
}