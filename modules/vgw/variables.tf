variable "location" {
  description = "Location name"
  default     = "North Europe"
  type        = string
}
variable "subscriptionId" {
  description = "Subscription Id"
  default     = ""
  type        = string
}
variable "environment" {
  description = "Environment: Dev, Test, Prod..."
  default     = "Dev"
  type        = string
}
variable "usage" {
  description = "The resource group usage - application or infrastructure"
  default     = "vpn"
  type        = string
}
variable "tags" {
  description = "Tags required for the resource groups and resources"
  default = {
    IaC             = "Terraform"
    environment     = "Dev"
    applicationName = "vNet Gateway"
    location        = "North Europe"
  }
  type = map(any)
}
variable "tenant_id" {
  description = "AAD tenant id"
  type        = string
}
variable "hubvirtualNetwork" {
  description = "The hub vNet and its associated subnets"
  default = {
    hub = {
      addressSpace = ["192.168.0.0/16"]
      dnsServers   = []
      subnets = {
        GatewaySubnet = ["192.168.0.0/24"]
      }
    }
  }
  type = map(any)
}
variable "vNetGateway" {
  description = "virtual Network Gateway configuration"
  default = {
    type                 = "Vpn"
    vpn_type             = "RouteBased"
    sku                  = "VpnGw1"
    bgp                  = false
    clientAddressSpace   = "172.16.0.0/24"
    root_certificate     = ""
    vpn_client_protocols = "OpenVPN"
    vpn_auth_types       = "AAD"
  }
  type = map(any)
}
