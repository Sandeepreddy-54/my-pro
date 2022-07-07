variable "name" {
  type        = string
  description = "App Service Plan name in Azure"
}
variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}

variable "location" {
  type        = string
  description = "RG location in Azure"
}

variable "app_service_plan_id" {
  description = "(Required) Specifies the App Service Plan ID within which to create the App Service."
  type        = string
}

variable "site_configs" {
  description = "(Optional) Specifies site configuration of the App Service."
  type        = list(map(any))
  default     = []
}

variable "app_settings" {
  description = "(Optional) Specifies a key-value pair of App Settings."
  type        = map(any)
  default     = {}
}
variable "tags" {
 type = map(string)
  description = "Define Azure Key Vault secrets in primary region"
  default     = {}
}
