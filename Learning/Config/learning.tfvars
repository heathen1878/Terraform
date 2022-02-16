environment = "learning"
usage = "testing"
hubvirtualNetwork = {
  hub = {
    addressSpace = ["192.168.0.0/22"]
    dnsServers = []
    subnets = {
      OpenVpn = ["192.168.1.0/24"]
      Clients = ["192.168.2.0/24"]
    }
  }
}
nsgRules = {
  Clients = {
    Rule1 = {
      name = "Allow_RDP_Tcp_In"
      priority = 1000
      protocol = "Tcp"
      direction = "Inbound"
      access = "Allow"
      description = ""
      source_port_range = "*"
      source_port_ranges = []
      destination_port_range = "3389"
      destination_port_ranges = []
      source_address_prefix = "Internet"
      source_address_prefixes = []
      destination_address_prefix = "VirtualNetwork"
      destination_address_prefixes = []
    }
    Rule2 = {
      name = "Allow_RDP_Udp_In"
      priority = 1001
      protocol = "Udp"
      direction = "Inbound"
      access = "Allow"
      description = ""
      source_port_range = "*"
      source_port_ranges = []
      destination_port_range = "3389"
      destination_port_ranges = []
      source_address_prefix = "Internet"
      source_address_prefixes = []
      destination_address_prefix = "VirtualNetwork"
      destination_address_prefixes = []
    }
    Rule3 = {
      name = "Allow_HTTP_HTTPS_Tcp_In"
      priority = 1002
      protocol = "Tcp"
      direction = "Inbound"
      access = "Allow"
      description = ""
      source_port_range = "*"
      source_port_ranges = []
      destination_port_range = ""
      destination_port_ranges = ["80", "443"]
      source_address_prefix = "Internet"
      source_address_prefixes = []
      destination_address_prefix = "VirtualNetwork"
      destination_address_prefixes = []
    }
  }
  OpenVpn = {
    Rule1 = {
      name = "Allow_SSH_Tcp_In"
      priority = 1000
      protocol = "Tcp"
      direction = "Inbound"
      access = "Allow"
      description = "Allow SSH Inbound"
      source_port_range = "*"
      source_port_ranges = []
      destination_port_range = "22"
      destination_port_ranges = []
      source_address_prefix = "Internet"
      source_address_prefixes = []
      destination_address_prefix = "VirtualNetwork"
      destination_address_prefixes = []
    }
  }
}