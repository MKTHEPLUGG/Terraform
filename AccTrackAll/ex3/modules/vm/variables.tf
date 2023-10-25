variable "resource_prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "myunique"  # You can set a default value here
}

variable "location" {
  type = string
  default = "westeurope"
}

variable "subnet_id" {
  description = "The ID of the subnet where the VM will be deployed"
  type        = string
}

variable "key_vault_key_uri" {
  description = "The URI of the key stored in Key Vault."
  type        = string
}

variable "key_vault_id" {
  description = "The ID of the Key Vault"
  type        = string
}

variable "key_name" {
  description = "The name of the key/secret in the Key Vault"
  type        = string
}

variable "secret_id" {
  description = "The ID of the secret to be read"
  type        = string
}

variable "secret_name" {
  description = "Name of the secret from the key vault module"
  type        = string
}


variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default = "test-tf-3"
}