terraform {
  backend "azurerm" {
    # this config is used to auth with azure blob for backend of tf state file, 
    # the values are to be defined in workflow via secrets
    # storage_account_name  = "tfstatestore12345"
    # container_name        = "tfstatecontainer"
    # key                   = "terraform.tfstate"
    # resource_group_name   = "TerraformStateRG"
    # client_id             = var.client_id
    # client_secret         = var.client_secret
    # tenant_id             = var.tenant_id
    # subscription_id       = var.subscription_id
  }
}