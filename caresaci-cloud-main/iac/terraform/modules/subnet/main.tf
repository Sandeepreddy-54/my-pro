resource "azurerm_subnet" "subnet" {
  address_prefixes                               = var.address_space
  name                                           = var.name
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = var.virtual_network_name
  service_endpoints                              = concat(var.additional_service_endpoints)
  

  dynamic "delegation" {
    for_each = var.delegations != null ? var.delegations : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}
