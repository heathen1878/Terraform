variable "subnets" {
  description = "A map of subnets to assign to a vNet"
  type = map(object(
    {
      name                 = string
      resource_group_name  = string
      virtual_network_name = string
      address_prefixes     = list(string)
      delegation = map(object(
        {
          name = optional(string)
          service_delegation = optional(object(
            {
              name    = optional(string)
              actions = optional(list(string))
            }
          ))
        }
        )
      )
      private_endpoint_network_policies_enabled     = optional(bool, true)
      private_link_service_network_policies_enabled = optional(bool, true)
      service_endpoints                             = optional(list(string))
      service_endpoint_policy_ids                   = optional(list(string))
    }
  ))
}