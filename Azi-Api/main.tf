provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "example" {
  name                 = "example-file-share"
  storage_account_name = azurerm_storage_account.example.name
  quota                = 50
}

resource "azurerm_logic_app_workflow" "example" {
  name                = "example-logic-app"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_logic_app_trigger_http_request" "example" {
  name         = "example-http-trigger"
  logic_app_id = azurerm_logic_app_workflow.example.id

  schema = <<SCHEMA
{
  "type": "object",
  "properties": {
    "name": {
      "type": "string"
    }
  }
}
SCHEMA
}

resource "azurerm_logic_app_action_custom" "example" {
  name         = "example-custom-action"
  logic_app_id = azurerm_logic_app_workflow.example.id
  body         = <<BODY
{
  "runAfter": {},
  "metadata": {
    "operationName": "DisassembleMessage"
  },
  "inputs": {
    "host": {
      "connection": {
        "name": "@parameters('$connections')['azureblob']['connectionId']"
      }
    },
    "method": "post",
    "path": "/datasets/default/files",
    "authentication": "@parameters('$authentication')"
  }
}
BODY
}

resource "azurerm_eventgrid_topic" "example" {
  name                = "example-eventgrid-topic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
