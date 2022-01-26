variable "location" {
    description = "Location name"
    default = "North Europe"
    type = string
}
variable "subscriptionId" {
    description = "Subscription Id"
    default = ""
    type = string 
}
variable "environment" {
    description = "Environment: Dev, Test, Prod..."
    default = "Dev"
    type = string
}
variable "usage" {
    description = "The resource group usage - application or infrastructure"
    default = "openvpn"
    type = string
}
variable "tags" {
    description = "Tags required for the resource groups and resources"
    default = {
        IaC = "Terraform"
        environment = "Learning"
        applicationName = "Open VPN"
        location = "North Europe"
    }
}
variable "keyVaultSku" {
    description = "Standard or Premium"
    type = string
    default = "standard"
}
variable "keyVaultAdmin" {
    description = "Group or User assigned Key Vault Administrator"
    type = string
}
variable "keyVaultSecretsOfficer" {
    description = "Group or User assigned Key Vault Secrets Officer"
    type = string
}
variable "keyVaultCertificatesOfficer" {
    description = "Group or User assigned Key Vault Certificates Officer"
    type = string
}
variable "hubvirtualNetwork" {
    description = "The hub vNet and its associated subnets"
    type = map
    default = {
        hub = {
            addressSpace = ["192.168.0.0/16"]
            dnsServers = []
            subnets = {
                GatewaySubnet = ["192.168.0.0/24"]
                OpenVpn = ["192.168.1.0/24"]
            }
        }
    }
}
variable "virtualMachines" {
    description = "Virtual Machines and their associated configurations"
    type = map
    default = {
        VM1 = {
            computerName = ""
            subnet = ""
            ipaddress = ""
            sku = ""
            username = ""
        }
    }
}