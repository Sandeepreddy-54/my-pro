#primary region

#create virtual network  for primary region
module "vnet_primary_region" {
	source              = ".//modules/virtual-network"
	name                = "virtualnetwork-${var.pro1}-${var.environment}-${var.primary_location}-${var.virtual_network_name}-001"

	location            = module.primary_resource_group.location
	resource_group_name = module.primary_resource_group.resource_group_name
	address_space       = ["192.168.0.0/18"]
	   tags = merge(var.sub_tags,{environment =var.environment},)   
}

 resource "azurerm_app_service_virtual_network_swift_connection" "swiftConnectionwebapi" {
  app_service_id = module.webapiservice_primary_region.id
  subnet_id      = module.webapi_subnet_primary.id
}
	 
#create network security group for api in primary region 
module "webapi_network_security_group_primary" {
    source              = ".//modules/network-security-group"
    name                = "webapinetworksecurity-${var.pro1}-${var.environment}-${var.primary_location}-${var.webapi_nsg_name}-001"
    resource_group_name = module.primary_resource_group.resource_group_name
    location            = module.primary_resource_group.location
	   tags = merge(var.sub_tags,{environment =var.environment},)  
}


#create subnet for api in primary region 
module "webapi_subnet_primary" {
  source              = ".//modules/subnet"
  name              = "webapisubnetprimary-${var.pro1}-${var.environment}-${var.primary_location}-${var.webapi_subnet_name}-001"

  virtual_network_name         = module.vnet_primary_region.name
  resource_group_name = module.primary_resource_group.resource_group_name
  address_space     = ["192.168.1.0/24"]
#   = ["Microsoft.Web"]
additional_service_endpoints    = [
    "Microsoft.Storage",
    "Microsoft.KeyVault",
    "Microsoft.Web",
    "Microsoft.Sql"
  ]
  }

	  


# NSG subnet association
resource "azurerm_subnet_network_security_group_association" "webapi_subnet_network_security_group_association_001" {
  subnet_id                 = module.webapi_subnet_primary.id
  network_security_group_id = module.webapi_network_security_group_primary.id     
}
	  
