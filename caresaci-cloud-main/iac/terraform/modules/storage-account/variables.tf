variable "account_kind" {
  description = "(Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Defaults to StorageV2."
  type        = string
  default     = "StorageV2"
}

variable "account_replication_type" {
  description = "(Optional) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS and ZRS. Defaults to LRS."
  type        = string
  default     = "LRS"
}

variable "enable_https_traffic_only" {
  description = "(Optional) Defines enable https traffic true or false"
  type        = bool
  default     = true
}

variable "account_tier" {
  description = "(Optional) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For FileStorage accounts only Premium is valid. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard"
}

variable "bypass" {
  description = "(Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None. Defaults to AzureServices"
  type        = string
  default     = "AzureServices"
}

variable "virtual_network_subnet_ids" {
  description = "(Optional) Adding virtual netowrk id"
  type        = string
  default     = "AzureServices"
}

variable "default_action" {
  description = "(Optional) Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow. Defaults to Deny."
  type        = string
  default     = "Deny"
}

variable "ip_rules" {
  type    = list(string)
  default = [
      "198.203.177.177",
      "198.203.175.175",
      "198.203.181.181",
      "168.183.84.12",
      "149.111.26.128",
      "149.111.28.128",
      "149.111.30.128",
      "220.227.15.70",
      "203.39.148.18",
      "161.249.192.14",
      "161.249.74.1",
      "161.249.72.14",
      "161.249.80.14",
      "161.249.96.14",
      "161.249.144.14",
      "161.249.176.14",
      "161.249.16.0/23",
      "12.163.96.0/24",
      "168.183.0.0/16",
      "149.111.0.0/16",
      "128.35.0.0/16",
      "161.249.0.0/16",
      "198.203.174.0/23",
      "198.203.176.0/22",
      "198.203.180.0/23",
      
  ]
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "(Required) Specifies the name of the storage account. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created."
  type        = string
}
variable "tags" {
 type = map(string)
  description = "Define Azure Key Vault secrets in primary region"
  default     = {}
}

