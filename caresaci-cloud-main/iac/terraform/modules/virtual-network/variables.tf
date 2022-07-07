variable "tags" {
 type = map(string)
  description = "Define Azure Key Vault secrets in primary region"
  default     = {}
}





variable "address_space" {
  type = list(string)
}

variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}
