variable "location" {
  description = "Location name"
  type        = string
}

variable "namespace" {
  description = "The namespace for the deployment e.g. mgt, dom, "
  type        = string
}

variable "state_storage_account" {
  description = "storage account where Terraform state is stored; primarily used by data resources"
  type        = string
}

variable "tenant_id" {
  description = "AAD tenant id"
  type        = string
}