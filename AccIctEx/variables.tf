variable "rgName" {
  description = "resource group name"
  type        = string
  default     = "tf-rg-2"
}

variable "location" {
  description = "location of the resourceGroup"
  type        = string
  default     = "westeurope"
}

variable "vault_name" {
  description = "name of the keyVault"
  type        = string
  default     = ""
}

variable "sku_name" {
  description = "name of the sku_type"
  type        = string
  // add a validation condition so it won't validate if the condition isn't met
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "The SKU name must be of the following: standard, permium"
  }
}

variable "key_type" {
  type    = string
  default = "RSA"
  validation {
    condition     = contains(["EC", "EC-HSM", "RSA", "RSA-HSM"], var.key_type)
    error_message = "The key must be either EC, EC-HSM, RSA or RSA-HSM"
  }
}

variable "key_size" {
  type    = number
  default = 2048
}

variable "key_opts" {
  type    = list(string)
  default = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

}

variable "key_name" {
  type    = string
  default = ""
}