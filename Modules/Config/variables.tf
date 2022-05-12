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
variable "namespace" {
    description = "The namespace for the deployment e.g. mgt, dom, "
    default = "ns1"
    type = string
}
variable "domain_suffix" {
    description = "A valid domain within AAD"
    type = string
}
variable "tags" {
    description = "Tags required for the resource groups and resources"
    default = {
        IaC = "Terraform"
        applicationName = "Configuration"
    }
    type = map
}
variable "virtual_networks" {
    description = "A virtual network for this environment"
    type = map(
        object(
            {
                address_space = list(string)
                dns_servers = list(string)
            }
        )
        )
}
############# 

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