variable "vnet_name" {
  type        = string
  description = "Name of the vnet"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "address space cidr"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "ddos_protection_plan_id" {
  type        = string
  default     = null
  description = "the ID of the ddos protection plan"
}

// list of vars in object
variable "subnets" {
  type = list(object({
    name                                          = string
    address_prefixes                              = list(string)
    service_endpoints                             = optional(list(string))
    private_endpoint_network_policies_enabled     = optional(bool)
    private_link_service_network_policies_enabled = optional(bool)
  }))
  default     = []
  description = "List of objects that represent the configuration of each subnet"
}