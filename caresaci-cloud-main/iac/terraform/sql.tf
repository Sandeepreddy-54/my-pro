resource "azurerm_mssql_server" "primary_sqldb_server" {
   name                         = "sqlserver-${var.pro}-${var.environment}-${var.primary_location}-${var.resource_group_name_primary}"

  resource_group_name          = module.primary_resource_group.resource_group_name
  location                     = module.primary_resource_group.location
  administrator_login          = "${var.environment}_appadmin"
  administrator_login_password = module.primary_key_vault.key-vault-secrets[0]
    version = "12.0"
   tags = merge(var.sub_tags,{environment =var.environment},)
   #   ssl_enforcement_enabled           = true
  }

  resource "azurerm_mssql_virtual_network_rule" "example" {
  name      = "sqlvirtualnetworkrule-${var.pro}-${var.environment}-${var.primary_location}-${var.resource_group_name_primary}"
  server_id = azurerm_mssql_server.primary_sqldb_server.id
  subnet_id = module.webapi_subnet_primary.id
}   
     
resource "azurerm_mssql_firewall_rule"  "primaryserver" {
  name                = "firewallprimary"
  # resource_group_name          = module.primary_resource_group.resource_group_name
 # location                     = module.primary_resource_group.location
   server_id         = azurerm_mssql_server.primary_sqldb_server.id
  start_ip_address    = "198.203.1.1"
  end_ip_address      = "198.203.255.255"
}
resource "azurerm_mssql_firewall_rule"  "accesstoazure" {
  name                = "access-to-azure"
  # resource_group_name          = module.primary_resource_group.resource_group_name
 # location                     = module.primary_resource_group.location
   server_id         = azurerm_mssql_server.primary_sqldb_server.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
resource "azurerm_mssql_server" "secondary_sqldb_server" {
  name                         = "sqlserver-${var.pro}-${var.environment}-${var.secondary_location}-${var.resource_group_name_secondary}"

  resource_group_name          = module.secondary_resource_group.resource_group_name
  location                     = module.secondary_resource_group.location
  administrator_login          = "${var.environment}_appadmin"
  administrator_login_password = module.secondary_key_vault.key-vault-secrets[0]
    
 version = "12.0"
     tags = merge(var.sub_tags,{environment =var.environment},)
    #  ssl_enforcement_enabled           = true
  }
     
resource "azurerm_mssql_firewall_rule"  "secondaryserver" {
  name                = "firewallsecondary"
   # resource_group_name          = module.secondary_resource_group.resource_group_name
 # location                     = module.primary_resource_group.location
  server_id         = azurerm_mssql_server.secondary_sqldb_server.id
  start_ip_address    = "198.203.1.1"
  end_ip_address      = "198.203.255.255"
}

resource "azurerm_mssql_database" "db1" {
  name                = "sqldatabase-${var.pro}-${var.environment}-${var.primary_location}-${var.resource_group_name_primary}"
  # resource_group_name = module.primary_resource_group.resource_group_name
#  location            = module.primary_resource_group.location
  server_id =azurerm_mssql_server.primary_sqldb_server.id
 collation = "SQL_Latin1_General_CP1_CI_AS"
license_type = "LicenseIncluded"
max_size_gb = 4
read_scale = true
sku_name = "BC_Gen5_2"
zone_redundant = true

}

resource "azurerm_mssql_database" "db2" {
  name                = "sqldatabase-${var.pro}-${var.environment}-${var.primary_location}-${var.resource_group_name_primary}"

  # resource_group_name          = module.secondary_resource_group.resource_group_name
 # location                     = module.secondary_resource_group.location
  server_id =azurerm_mssql_server.secondary_sqldb_server.id
  collation = "SQL_Latin1_General_CP1_CI_AS"
license_type = "LicenseIncluded"
# max_size_gb = 4
read_scale = true
sku_name = "BC_Gen5_2"
zone_redundant = true
 
  create_mode = "OnlineSecondary"
 creation_source_database_id = azurerm_mssql_database.db1.id
}
