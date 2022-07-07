#key vault in primary region
module "primary_key_vault" {
  source              = ".//modules/key-vault"
  name                = "keyvault-${var.pro}-${var.environment}-01"
  location            = module.primary_resource_group.location
  resource_group_name = module.primary_resource_group.resource_group_name
  secrets = var.kv-primary-secrets   
    tags = merge(var.sub_tags,{environment =var.environment},)


}
module "secondary_key_vault" {
  source              = ".//modules/key-vault"
  name                = "keyvault-${var.pro}-${var.environment}-02"
  location            = module.secondary_resource_group.location
  resource_group_name = module.secondary_resource_group.resource_group_name
  secrets = var.kv-secondary-secrets 
    tags = merge(var.sub_tags,{environment =var.environment},)


}
    

 

resource "random_integer" "ki" {
  min = 10000
  max = 99999
}    

resource "random_string" "keyrandom" {
  length           = 16
  special          = true
  override_special = "/@£$"
}
