output "error_404_document" {
  value       = azurerm_storage_account.storage_account.static_website[*].error_404_document
  description = "The absolute path to a custom webpage that should be used when a request is made which does not correspond to an existing file."
}

output "id" {
  value       = azurerm_storage_account.storage_account.id
  description = "The storage account Resource ID."
}

output "name" {
  value       = azurerm_storage_account.storage_account.name
  description = "The storage account Resource name."
}

output "primary_access_key" {
  value       = azurerm_storage_account.storage_account.primary_access_key
  description = "The primary access key for the storage account."
  sensitive   = true
}

output "primary_blob_connection_string" {
  value       = azurerm_storage_account.storage_account.primary_blob_connection_string
  description = "The connection string associated with the primary blob location."
  sensitive   = true
}

output "primary_blob_endpoint" {
  value       = azurerm_storage_account.storage_account.primary_blob_endpoint
  description = "The endpoint URL for blob storage in the primary location."
}

output "primary_blob_host" {
  value       = azurerm_storage_account.storage_account.primary_blob_host
  description = "The hostname with port if applicable for blob storage in the primary location."
}

output "primary_connection_string" {
  value       = azurerm_storage_account.storage_account.primary_connection_string
  description = "The connection string associated with the primary location."
  sensitive   = true
}

output "primary_dfs_endpoint" {
  value       = azurerm_storage_account.storage_account.primary_dfs_endpoint
  description = "The endpoint URL for DFS storage in the primary location."
}

output "primary_dfs_host" {
  value       = azurerm_storage_account.storage_account.primary_dfs_host
  description = "The hostname with port if applicable for DFS storage in the primary location."
}

output "primary_file_endpoint" {
  value       = azurerm_storage_account.storage_account.primary_file_endpoint
  description = "The endpoint URL for file storage in the primary location."
}

output "primary_file_host" {
  value       = azurerm_storage_account.storage_account.primary_file_host
  description = "The hostname with port if applicable for file storage in the primary location."
}

output "primary_location" {
  value       = azurerm_storage_account.storage_account.primary_location
  description = "The primary location of the storage account."
}

output "primary_queue_endpoint" {
  value       = azurerm_storage_account.storage_account.primary_queue_endpoint
  description = "The endpoint URL for queue storage in the primary location."
}

output "primary_queue_host" {
  value       = azurerm_storage_account.storage_account.primary_queue_host
  description = "The hostname with port if applicable for queue storage in the primary location."
}

output "primary_table_endpoint" {
  value       = azurerm_storage_account.storage_account.primary_table_endpoint
  description = "The endpoint URL for table storage in the primary location."
}

output "primary_table_host" {
  value       = azurerm_storage_account.storage_account.primary_table_host
  description = "The hostname with port if applicable for table storage in the primary location."
}

output "primary_web_endpoint" {
  value       = azurerm_storage_account.storage_account.primary_web_endpoint
  description = "The endpoint URL for web storage in the primary location."
}

output "primary_web_host" {
  value       = azurerm_storage_account.storage_account.primary_web_host
  description = "The hostname with port if applicable for web storage in the primary location."
}
