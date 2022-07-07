variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}
variable "default_tags" {
 type = map(string)
  description = "Define Azure Key Vault secrets in primary region"
  default     = {}
}

variable "additional_service_endpoints" {
  type = list(string)
  default = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Web","Microsoft.Web/serverFarms","Microsoft.Sql"]
}

variable "address_space" {
  type = list(string)
}

variable "virtual_network_name" {
  type = string
}

variable "delegations" {
    type = list(object({
      service_delegation = object({
        name    = string
        actions = list(string)
      })
      name = string
    }))
  default = [{
        service_delegation = {
                        name    = "Microsoft.Web/serverFarms"
                        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
                    }
        name = "delegation"
  }]
}

