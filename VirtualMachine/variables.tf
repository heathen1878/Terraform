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
    default = ""
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
            addressSpace = ["10.0.0.0/16"]
            dnsServers = []
            subnets = {
                subnet = ["10.0.0.0/24"]
            }
        }
    }
}
variable "nsgRules" {
    description = "A map of rules"
    type = map(
        map(
            object(
                {
                    name = string
                    priority = number
                    protocol = string
                    direction = string
                    access = string
                    description = string
                    source_port_range = string
                    source_port_ranges = list(string)
                    destination_port_range = string
                    destination_port_ranges = list(string)
                    source_address_prefix = string
                    source_address_prefixes = list(string)
                    destination_address_prefix = string
                    destination_address_prefixes = list(string)
                }
            )
        )
    )
}
variable "linuxVirtualMachines" {
    description = "Linux Virtual Machines and their associated configurations"
    type = map
    default = {
    }
}
variable "winVirtualMachines" {
    description = "Windows Virtual Machines and their associated configurations"
    type = map
    default = {
    }
}