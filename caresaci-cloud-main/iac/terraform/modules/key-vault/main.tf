data "azurerm_client_config" "current" {}

# Create the Azure Key Vault
resource "azurerm_key_vault" "key-vault" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  purge_protection_enabled    = true
  
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = var.sku_name
  #tags1      = var.tags
    tags=var.tags
  }

# Create a Default Azure Key Vault access policy with Admin permissions
# This policy must be kept for a proper run of the "destroy" process
resource "azurerm_key_vault_access_policy" "default_policy" {
  key_vault_id = azurerm_key_vault.key-vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    =data.azurerm_client_config.current.object_id

  lifecycle {
    create_before_destroy = true
  }

  
  key_permissions = var.kv-key-permissions-read
  secret_permissions = var.kv-secret-permissions-read
  certificate_permissions = var.kv-certificate-permissions-read
  storage_permissions = var.kv-storage-permissions-read
}

# Create an Azure Key Vault access policy
resource "azurerm_key_vault_access_policy" "policy" {
  for_each                = var.policies
  key_vault_id            = azurerm_key_vault.key-vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = lookup(each.value, "object_id")
  key_permissions         = lookup(each.value, "key_permissions")
  secret_permissions      = lookup(each.value, " secret_permissions")
  certificate_permissions = lookup(each.value, "certificate_permissions")
  storage_permissions     = lookup(each.value, "storage_permissions")
}

resource "time_rotating" "time_rotate_example" {
  rotation_days = var.rotation_days
}


# Generate a random password
resource "random_password" "password" {
  for_each    = var.secrets
  length      = 20
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2

  keepers = {
   rotation = time_rotating.time_rotate_example.id
  }
}

# Create an Azure Key Vault secrets
resource "azurerm_key_vault_secret" "secret" {
  for_each     = var.secrets
  key_vault_id = azurerm_key_vault.key-vault.id
  name         = each.key
  value        = lookup(each.value, "value") != "" ? lookup(each.value, "value") : random_password.password[each.key].result
  tags         = var.tags
  depends_on = [
    azurerm_key_vault.key-vault,
    azurerm_key_vault_access_policy.default_policy,
  ]
}
