# Create new resource group
module "primary_resource_group" {
  source              = ".//modules/resource-group"
  resource_group_name = "${var.resource_group_name}_${var.environment}_${var.primary_location}_${var.resource_group_name_primary}"
  location            = var.primary_location
     tags = merge(var.sub_tags,{environment =var.environment},)
}

module "secondary_resource_group" {
  source              = ".//modules/resource-group"
  resource_group_name = "${var.resource_group_name}_${var.environment}_${var.secondary_location}_${var.resource_group_name_secondary}"
    tags = merge(var.sub_tags,{environment =var.environment},)
   location            = var.secondary_location
}
	

#create application insights for web api in primary region
module "webapi_appinsights_primary_region" {
	source              = ".//modules/application-insights"
	name                = "webapiinsights_${var.pro1}_${var.environment}_${var.primary_location}_001"
	location            = module.primary_resource_group.location
	 tags = merge(var.sub_tags,{environment =var.environment},)	
	resource_group_name = module.primary_resource_group.resource_group_name
}
		

		
module "webapp_appinsights_primary_region" {
	source              = ".//modules/application-insights"
	name                = "webappinsights_${var.pro1}_${var.environment}_${var.primary_location}_001"
	location            = module.primary_resource_group.location
	resource_group_name = module.primary_resource_group.resource_group_name
	 tags = merge(var.sub_tags,{environment =var.environment},)	
}

#create app service plan in primary region
module "appserviceplan_primary_region" {
	source              = ".//modules/app-service-plan"
	name  = "appplan_${var.pro1}_${var.environment}_${var.primary_location}_001"
	location   = module.primary_resource_group.location
	resource_group_name = module.primary_resource_group.resource_group_name
  app_service_plan_id= module.webappservice_primary_region.id
	     tags = merge(var.sub_tags,{environment =var.environment},)	  
}



#create web app service in primary region's app service plan
module "webappservice_primary_region" {
	source              = ".//modules/app-service"
	name	= "webapp-${var.pro}-${var.environment}-${var.primary_location}"

	resource_group_name = module.primary_resource_group.resource_group_name
	location            = module.primary_resource_group.location
  app_service_plan_id = module.appserviceplan_primary_region.id
      tags = merge(var.sub_tags,{environment =var.environment},)
	  	app_settings = {
		"APPINSIGHTS_INSTRUMENTATIONKEY"		= module.webapi_appinsights_primary_region.instrumentation_key
		"APPLICATIONINSIGHTS_CONNECTION_STRING" = module.webapi_appinsights_primary_region.connection_string
  }
  site_configs = [{
	ip_restriction = [{
		service_tag = "AzureFrontDoor.Backend"
		name = "allow-only-front-door"
		priority = 200
		action = "Allow"
		headers	= []
		ip_address = null
		virtual_network_subnet_id = null
	}]
  }]
       
}
#create web api service in primary region's app service plan
module "webapiservice_primary_region" {
	source              = ".//modules/app-service"
	name				= "webapi-${var.pro}-${var.environment}-${var.primary_location}"

	resource_group_name = module.primary_resource_group.resource_group_name
	location            = module.primary_resource_group.location
	app_service_plan_id = module.appserviceplan_primary_region.id
		
     tags = merge(var.sub_tags,{environment =var.environment},)
			app_settings = {
		"APPINSIGHTS_INSTRUMENTATIONKEY"		= module.webapi_appinsights_primary_region.instrumentation_key
		"APPLICATIONINSIGHTS_CONNECTION_STRING" = module.webapi_appinsights_primary_region.connection_string
  }
   
}
# Create new resource group

# Generate a random integer to create a globally unique name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}
resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}
