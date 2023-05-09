variable "location" {
  description = "Location name"
  default     = "North Europe"
  type        = string
}
variable "environment" {
  description = "Environment: Dev, Test, Prod..."
  default     = "Dev"
  type        = string
}
variable "namespace" {
  description = "The namespace for the deployment e.g. mgt, dom, "
  default     = "ns1"
  type        = string
}
variable "tags" {
  description = "Tags required for the resource groups and resources"
  default = {
    IaC             = "Terraform"
    applicationName = "Secrets"
  }
}
variable "tenant_id" {
  description = "AAD tenant id"
  type = string  
}