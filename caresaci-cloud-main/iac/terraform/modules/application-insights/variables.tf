variable "location" {
  description = "(Required) Specifies the supported Azure location where the App Service should exist. Changing this forces a new resource to be created."
  type        = string
}
variable "tags" {
 type = map(string)
  description = "Define Azure Key Vault secrets in primary region"
  default     = {}
}
variable "name" {
  description = "(Optional) Specifies the name of the App Service. Changing this forces a new resource to be created. Positioned at the beginning of the calculated resource name. Defaults to `appservice`."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the resource group in which to create the App Service."
  type        = string
}

variable "application_type" {
  description = "(Required) Specifies the type of the App Service for which application insight is created."
  type        = string
  default     = "web"
}
