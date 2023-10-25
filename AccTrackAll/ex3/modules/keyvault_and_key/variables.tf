variable "rgName" {
  description = "Name of the resource group"
  type        = string
  default = "test-tf-3"
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
  default = "westeurope"
}

variable "vault_name" {
  description = "Name for the Key Vault"
  type        = string
  default     = null
}

variable "sku_name" {
  description = "SKU name for the Key Vault"
  type        = string
  default     = "standard"
}

variable "key_type" {
  description = "Type of the key to create in Key Vault"
  type        = string
  default     = "RSA"
}

variable "key_size" {
  description = "Size of the key to create in Key Vault"
  type        = number
  default     = 2048
}

variable "key_opts" {
  description = "Key operations for the key in Key Vault"
  type        = list(string)
  default     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
}

variable "key_name" {
  description = "Name for the key in Key Vault"
  type        = string
  default     = null
}
