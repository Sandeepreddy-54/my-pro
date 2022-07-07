variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "RG location in Azure"
}

variable "name" {
  type        = string
  description = "App Service Plan name in Azure"
}

variable "app_service_plan_id" {
  description = "(Required) Specifies the App Service Plan ID within which to create the App Service."
  type        = string
}

variable "sku" {
  description = "(Required) Specifies the App Service Plan SKU."
  type = object({
    tier     = string
    size     = string
  })
  default = {
	  tier = "Standard"
    size = "S1"
	}
}

variable "tags" {
 type = map(string)
  description = "Define Azure Key Vault secrets in primary region"
  default     = {}
}

