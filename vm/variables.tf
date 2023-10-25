variable "client_id" {
  description = "Azure Client ID"
  type        = string
}

variable "client_secret" {
  description = "Azure Client Secret"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "myunique" # You can set a default value here
}

variable "resource_group_name" {
  description = "Name of the resource group required"
  type        = string
  default     = "test-tf-3"
}