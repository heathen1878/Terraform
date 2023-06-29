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
      associated_web_app   = optional(string)
      type                 = optional(string, "A")
      ttl                  = optional(number, 3600)
      proxy_status         = optional(bool, true)
      zone_key             = optional(string)
      content              = optional(string)
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
  default     = {}
  type = map(object(
    {
      resource_group = string
      rules = map(object(
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
      ))
      tags = optional(map(any))
    }
  ))
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
  default     = {}
  type = map(
    object(
      {
        resource_group = string
        address_space  = list(string)
        dns_servers    = list(string)
        peers          = list(string)
      }
    )
  )
}
