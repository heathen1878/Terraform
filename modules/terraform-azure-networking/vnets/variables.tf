variable "virtual_networks" {
  description = "A map of virtual networks"
  type = map(object(
    {
      name                = string
      resource_group_name = string
      location            = string
      address_space       = list(string)
      dns_servers         = optional(list(string), [])
      bgp_community       = optional(string)
      ddos_protection_plan = optional(object(
        {
          id     = string
          enable = bool
        }
        ), {
        id     = ""
        enable = false
      })
      edge_zone               = optional(string)
      flow_timeout_in_minutes = optional(number, 30)
      tags                    = map(any)
    }
  ))
}