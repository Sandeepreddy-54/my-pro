variable "tableName" {
  type        = string
  description = "Table name"
}

variable "secret_adf_az_sql_name" {
  description = "The name of the key vault secret for azure sql server"
}
variable "pipelineId" {
  type        = string
  description = "PipelinedId."
}

variable "resource_group_name_primary" {
  description = "The name of the primary resource group."
}

variable "resource_group_name" {
  description = "The name of the resource group."
}

variable "pro" {
  description = "The name of the common group."
}

variable "pro1" {
  description = "The name of the common group of 1."
}

variable "pro2" {
  description = "The name of the common group of storage."
}

variable "data_factory_name" {
  description = "The name of the data factory name."
}
variable "azir_name" {
  description = "Name for Azure Integration Runtime Instance"
}
variable "primary_location" {
  description = "The primary location to deploy resources to."
}
variable "app_primary_storage_account" {
  description = "The name of the wmd storage account in primary region."
}
variable "resource_group_name_adf" {
  description = "The name of the resource group in which Azure Data Factory created."
}

variable "environment" {
  description = "The name of the environment that is being deployed"
}

variable "virtual_network_name" {
  description = "The name of the virtual network."
}

variable "webapp_subnet_name" {
  description = "The name of the web app subnet to create in the virtual network."
}

variable "webapi_subnet_name" {
  description = "The name of the web api subnet to create in the virtual network."
}

variable "webapp_nsg_name" {
  description = "The name of the network security group that is attached to the webapp subnet."
}

variable "webapi_nsg_name" {
  description = "The name of the network security group that is attached to the webapi subnet."
}




variable "resource_group_name_secondary" {
  description = "The name of the secondary resource group."
}

variable "secondary_location" {
  description = "The secondary location to deploy resources to."
}

variable "resource_group_name_frontdoor" {
  description = "The name of the front door resource group."
}

variable "frontdoor_location" {
  description = "The  location of the front door"
}

variable "domain_name" {
  description = "The  location of the front door"
}


#######################
# Key Vault variables #
#######################

variable "kv-full-object-id" {
  type        = string
  description = "The object ID of a user, service principal or security group in the Azure Active Directory tenant for FULL access to the Azure Key Vault"
  default     = ""
}

variable "azure-tenant-id" {
  type        = string
  description = "The object ID of a user, service principal or security group in the Azure Active Directory tenant for FULL access to the Azure Key Vault"
  default     = ""
}

variable "kv-read-object-id" {
  type        = string
  description = "The object ID of a user, service principal or security group in the Azure Active Directory tenant for READ access to the Azure Key Vault"
  default     = ""
}
variable "tableList" {
  type    = list(string)
  default = ["us-west-1a"]
  description = "tables list array"
}
variable "kv-vm-deployment" {
  type        = string
  description = "Allow Azure Virtual Machines to retrieve certificates stored as secrets from the Azure Key Vault"
  default     = "true"
}

variable "kv-disk-encryption" {
  type        = string
  description = "Allow Azure Disk Encryption to retrieve secrets from the Azure Key Vault and unwrap keys" 
  default     = "true"
}

variable "kv-template-deployment" {
  type        = string
  description = "Allow Azure Resource Manager to retrieve secrets from the Azure Key Vault"
  default     = "true"
}

variable "kv-key-permissions-full" {
  type        = list(string)
  description = "List of full key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey"
  default     = [ "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List"," Purge"," Recover"," Restore"," Sign"," UnwrapKey"," Update"," Verify", "WrapKey"]
}


variable "kv-secret-permissions-full" {
  type        = list(string)
  description = "List of full secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set"
  default     = [ "Backup"," Delete"," Get"," List"," Purge"," Recover"," Restore", "Set"]
} 

variable "kv-certificate-permissions-full" {
  type        = list(string)
  description = "List of full certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update"
  default     = [ "Backup"," Create"," Delete"," DeleteIssuers"," Get"," GetIssuers"," Import"," List"," ListIssuers"," ManageContacts"," ManageIssuers"," Purge"," Recover"," Restore"," SetIssuers","Update" ]
}

variable "kv-storage-permissions-full" {
  type        = list(string)
  description = "List of full storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update"
  default     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update" ]
}

variable "kv-key-permissions-read" {
  type        = list(string)
  description = "List of read key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey"
  default     = [ "Get", "List" ]
}

variable "kv-secret-permissions-read" {
  type        = list(string)
  description = "List of full secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set"
  default     = [ "Get", "List"]
} 

variable "kv-certificate-permissions-read" {
  type        = list(string)
  description = "List of full certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update"
  default     = [ "Get", "GetIssuers", "List", "ListIssuers" ]
}

variable "kv-storage-permissions-read" {
  type        = list(string)
  description = "List of read storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update"
  default     = [ "Get", "Getsas", "List", "ListSAS" ]
}

variable "kv-primary-secrets" {
  type = map(object({
    value = string
  }))
  description = "Define Azure Key Vault secrets in primary region"
  default     = {}
}

variable "kv-secondary-secrets" {
  type = map(object({
    value = string
  }))
  description = "Define Azure Key Vault secrets in secondary region"
  default     = {}
}



variable "front_door_name" {
    type        = string
  description = "The name of the azure front door"
}


variable "shir_name" {
    type        = string
  description = "Name for Self Hosted Integration Runtime Instance"
}



variable "sub_tags" {
 type = map(string)
  description = "Define Azure Key Vault secrets in primary region"
  default= { }
 }
variable "service_endpoints" {
  type = list(string)
  default = []
}
variable "bypass" {
  description = "(Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None. Defaults to AzureServices"
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
