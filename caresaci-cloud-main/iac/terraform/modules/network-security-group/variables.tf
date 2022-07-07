variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "security_rules" {
  type = list(object({
    name                         = string
    access                       = string
    direction                    = string
    priority                     = number
    protocol                     = string
    source_address_prefix        = string
    source_port_range            = string
    destination_address_prefix   = string
    destination_port_range       = string
  }))
  default = [{
        name                       = "AllowVnetOutboundSql"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "Sql.CentralUS"
  },
  {
        name                       = "DenyAllSQLOutbound"
        priority                   = 200
        direction                  = "Outbound"
        access                     = "Deny"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
  }]
}
variable "tags" {
 type = map(string)
  description = "Define Azure Key Vault secrets in primary region"
  default     = {}
}
