output "id" {
  description = "The ID of the App Service Plan component."
  value       = azurerm_service_plan.plan.id
}

output "location" {
  description = "The supported Azure location where the App Service Plan exists."
  value       = azurerm_service_plan.plan.location
}

output "name" {
  description = "The name of the App Service Plan component."
  value       = azurerm_service_plan.plan.name
}

output "resource_group_name" {
  description = "The name of the resource group in which the App Service Plan component is created."
  value       = azurerm_service_plan.plan.resource_group_name
}