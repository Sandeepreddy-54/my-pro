#primary region
module "primary_storage_account_001" {
  source					= ".//modules/storage-account"
  name                      = "osd${var.environment}${var.primary_location}${var.app_primary_storage_account}"  

resource_group_name       =  module.primary_resource_group.resource_group_name
  location                  =  module.primary_resource_group.location
  
    tags = merge(var.sub_tags,{environment =var.environment},)
    
}

resource "azurerm_storage_container" "primary_storage_container_001" {
  name                  = "container${var.pro2}${var.environment}${var.primary_location}${random_integer.ri.result}"

  storage_account_name  = module.primary_storage_account_001.name
  container_access_type = "private"
  
    
}
