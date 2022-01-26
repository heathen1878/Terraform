location = "West Europe"
environment = "Test"
tags = {
    IaC = "Terraform"
    environment = "Test"
    applicationName = "Open VPN"
    location = "West Europe"
}
hubvirtualNetwork = {
    hub = {
        addressSpace = ["10.0.0.0/16"]
        dnsServers = []
        subnets = {
            GatewaySubnet = ["10.0.0.0/24"]
            OpenVpn = ["10.0.1.0/24"]
        }
    }
}
virtualMachines = {
    VM1 = {
        computerName = "openvpn1"
        subnet = "OpenVpn"
        ipaddress = "10.0.1.101"
    }
    VM2 = {
        computerName = "openvpn2"
        subnet = "OpenVpn"
        ipaddress = "10.0.1.102"
    }
    VM22 = {
        computerName = "openvpn22"
        subnet = "OpenVpn"
        ipaddress = "10.0.1.122"
    }    
}