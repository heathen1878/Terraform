variable "location" {
    description = "Location name"
    default = "North Europe"
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
        applicationName = "Configurations"
        location = "North Europe"
    }
    type = map
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