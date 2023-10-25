variable "resource_prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "myunique"  # You can set a default value here
}

variable "location" {
  type = string
  default = "westeurope"
}

variable "rgName" {
  description = "Name of the resource group"
  type        = string
  default = "test-tf-3"
}