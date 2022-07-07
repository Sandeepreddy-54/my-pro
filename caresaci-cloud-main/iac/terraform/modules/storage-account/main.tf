resource "azurerm_storage_account" "storage_account" {
  name                      = var.name
  # account_kind              = var.account_kind
  account_replication_type  = var.account_replication_type
  account_tier              = var.account_tier
 # enable_https_traffic_only = var.enable_https_traffic_only
  location                  = var.location
  resource_group_name       = var.resource_group_name
    tags=var.tags

  network_rules {
     bypass                     = [var.bypass]
    default_action             = var.default_action
    ip_rules                   = var.ip_rules
  #  virtual_network_subnet_ids= var.virtual_network_subnet_ids
  }
}
