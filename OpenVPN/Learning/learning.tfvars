environment = "Learning"
tags = {
    IaC = "Terraform"
    environment = "Learning"
    applicationName = "Open VPN"
    location = "North Europe"
}
hubvirtualNetwork = {
    hub = {
        addressSpace = ["10.1.0.0/16"]
        dnsServers = []
        subnets = {
            GatewaySubnet = ["10.1.0.0/24"]
            OpenVpn = ["10.1.1.0/24"]
        }
    }
}
virtualMachines = {
    VM1 = {
        computerName = "openvpn1"
        subnet = "OpenVpn"
        ipaddress = "10.1.1.101"
    }
    VM2 = {
        computerName = "openvpn2"
        subnet = "OpenVpn"
        ipaddress = "10.1.1.102"
    }
    VM22 = {
        computerName = "openvpn22"
        subnet = "OpenVpn"
        ipaddress = "10.1.1.122"
    }    
}