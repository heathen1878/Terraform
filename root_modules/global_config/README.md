# Networking examples

```go
    GatewaySubnet = {
      address_space_block = 0
      octet               = 1
      subnet_size         = 11
    }
    dnsinbound = {
      address_space_block = 0
      delegations = {
        dns_resolver = {
          name = "dnsResolvers"
          service_delegation = {
            name = "Microsoft.Network/dnsResolvers"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action"
            ]
          }
        }
      }
      octet       = 2
      subnet_size = 8
    }
```