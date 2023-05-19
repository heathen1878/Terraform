variable "dns_resolver" {
  description = "A map of private dns resolver configuration"
  type = map(object(
    {
      name                       = string
      resource_group_name        = string
      location                   = string
      virtual_network_id         = string
      inbound_resolver_name      = string
      inbound_resolver_subnet_id = string
      tags = map(any)
    }
  ))
}