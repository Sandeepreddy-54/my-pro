
resource "azurerm_service_plan" "plan"{
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "P1v2"
  os_type             = "Windows"
   tags=var.tags
  

}

