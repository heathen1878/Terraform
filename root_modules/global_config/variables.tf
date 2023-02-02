variable "access_token" {
  description = "Authentication access token used for querying APIs"
  type        = string
}
variable "bootstrap" {
  description = "The Key Vault that contains secrets for bootstrapping Terraform Configuration"
  type = map(object(
    {
      name           = string
      resource_group = string
    }
  ))
}

variable "container_groups" {
  description = "A map of container instances to deploy"
  default     = {}
  type = map(
    map(
      object(
        {
          acr                          = string
          acr_image                    = string
          name                         = string
          environment_variables        = string
          secure_environment_variables = string
        }
      )
    )
  )
  sensitive = true
}
variable "domain_suffix" {
  description = "A valid domain within AAD"
  default     = "domain.com"
  type        = string
}
variable "environment" {
  description = "Environment: Dev, Test, Prod..."
  default     = "Dev"
  type        = string
}
variable "location" {
  description = "Location name"
  default     = "northeurope"
  type        = string
}
variable "management_groups" {
  description = "A map of management groups to manage"
  default     = {}
  type = map(object
    (
      {
        display_name  = string
        subscriptions = list(string)
      }
    )
  )
}
variable "namespace" {
  description = "The namespace for the deployment e.g. mgt, dom, "
  default     = "ns1"
  type        = string
}
variable "nsg_rules" {
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
variable "tags" {
  description = "Tags required for the resource groups and resources"
  default = {
    IaC             = "Terraform"
    applicationName = "Configuration"
  }
  type = map(any)
}
variable "tenant_id" {
  description = "AAD tenant id"
  type        = string
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
