variable "bootstrap" {
  description = "The Key Vault that contains secrets for bootstrapping Terraform Configuration"
  type = map(object(
    {
      name           = string
      resource_group = string
    }
  ))
}

variable "cloudflare_account_name" {
  description = "The name representation of the cloudflare account"
  default     = ""
  type        = string
}

variable "dns_records" {
  description = "A map of DNS records"
  default     = {}
  type = map(object(
    {
      azure_managed        = optional(bool, false)
      cloudflare_protected = optional(bool, false)
      content              = string
      type                 = optional(string, "A")
      ttl                  = optional(number, 3600)
      proxy_status         = optional(bool, true)
      zone_key             = string
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
          acr                   = string
          acr_image             = string
          name                  = string
          environment_variables = string
        }
      )
    )
  )
}

variable "dns_zones" {
  description = "A map of dns zones"
  default = {
    azure_managed = {
      name                 = "domain.com"
      azure_managed        = true
      cloudflare_protected = false
      resource_group       = "rg_key"
      tags = {
        key = "value"
      }
    }
    cloudflare_protected = {
      name                 = "domain.com"
      azure_managed        = false
      cloudflare_protected = true
      jump_start           = false
      paused               = false
      plan                 = "free"
      type                 = "full"
    }
  }
  type = map(object(
    {
      name                 = string
      azure_managed        = bool
      cloudflare_protected = bool
      resource_group       = optional(string, "demo")
      tags                 = optional(map(any))
      jump_start           = optional(bool, false)
      paused               = optional(bool, false)
      plan                 = optional(string, "free")
      type                 = optional(string, "full")
    }
  ))
}

variable "domain_suffix" {
  description = "A valid domain within AAD"
  default     = "domain.com"
  type        = string
}

variable "environment" {
  description = "Environment: Dev, Test, Prod..."
  type        = string
}

variable "location" {
  description = "Location name"
  type        = string
}

variable "management_groups" {
  description = "A map of management groups to manage"
  default     = {}
  type = map(object(
    {
      display_name  = string
      subscriptions = list(string)
    }
  ))
}

variable "management_subscription" {
  description = "The management subscription id"
  type        = string
}

variable "namespace" {
  description = "The namespace for the deployment e.g. mgt, dom, "
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

variable "state_storage_account" {
  description = "storage account where Terraform state is stored; primarily used by data resources"
  default     = ""
  type        = string
}

variable "tags" {
  description = "Tags required for the resource groups and resources"
  default = {
    iac = "terraform"
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
