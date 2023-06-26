variable "access_token" {
  description = "Authentication access token used for querying APIs"
  default     = ""
  type        = string
}

variable "azure_ip_ranges_json_url" {
  type        = string
  default     = ""
  description = "The download link for Azure IP ranges json file. Set in setup.sh"
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
  default     = null
  type        = string
}

variable "location" {
  description = "Location name"
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

variable "management_subscription" {
  description = "The management subscription id"
  type        = string
}

variable "namespace" {
  description = "The namespace for the deployment e.g. global, mgt..."
  default     = "global"
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
    IaC = "Terraform"
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
