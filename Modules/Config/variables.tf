variable "location" {
  description = "Location name"
  default     = "northeurope"
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
variable "domain_suffix" {
  description = "A valid domain within AAD"
  default     = "domain.com"
  type        = string
}
variable "tags" {
  description = "Tags required for the resource groups and resources"
  default = {
    IaC             = "Terraform"
    applicationName = "Configuration"
  }
  type = map(any)
}
variable "virtual_networks" {
  description = "A virtual network for this environment"
  default = {
    "ns1-dev-northeurope" = {
      address_space = [
        "192.168.254.0/24"
      ]
      dns_servers = []
    }
  }
  type = map(
    object(
      {
        address_space = list(string)
        dns_servers   = list(string)
      }
    )
  )
}
variable "nsgRules" {
  description = "A map of rules"
  default = {
    "default" = {
      "default" = {
        access                       = "Deny"
        description                  = "Default rule - Allow SSH access when access = Allowed"
        destination_address_prefix   = "VirtualNetwork"
        destination_address_prefixes = []
        destination_port_range       = "22"
        destination_port_ranges      = []
        direction                    = "Inbound"
        name                         = "Default_SSH_Inbound"
        priority                     = 1000
        protocol                     = "Tcp"
        source_address_prefix        = "*"
        source_address_prefixes      = []
        source_port_range            = "*"
        source_port_ranges           = []
      }
    }
  }
  type = map( # reference to subnet
    map(      # rule 
      object( # rule configuration
        {
          name                         = string
          priority                     = number
          protocol                     = string
          direction                    = string
          access                       = string
          description                  = string
          source_port_range            = string
          source_port_ranges           = list(string)
          destination_port_range       = string
          destination_port_ranges      = list(string)
          source_address_prefix        = string
          source_address_prefixes      = list(string)
          destination_address_prefix   = string
          destination_address_prefixes = list(string)
        }
      )
    )
  )
}