output "webapp_url" {
  value = module.webappservice_primary_region.name

}

	
output "resource_group_name" {
  value="module.primary_resource_group.resource_group_name"
}


output "id" {
  value="azurerm_mssql_server.primary_sqldb_server.id"
} 

output "app_service_plan_id" {
value=module.webappservice_primary_region.id  
}