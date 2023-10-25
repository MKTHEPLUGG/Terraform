variable "resource_prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "myunique"  # You can set a default value here
}

variable "location" {
  type = string
  default = "westeurope"
}

variable "resourceGroup" {
  type = string
  default = "Test-RG-TF"
}
