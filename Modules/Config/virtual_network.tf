locals {

    virtual_network_subnets = {
        
    }

    # ---------------------------------------------------------------------------------------------------------------------
    # LOCAL CALCULATED
    # ---------------------------------------------------------------------------------------------------------------------
    
    virtual_networks_output = {
        format("%s_%s", var.namespace, var.environment) = {
            name = azurecaf_name.virtual_network.result
            resource_group_name = azurecaf_name.resource_group.result
            location = var.location
            address_space = var.virtual_networks[format("%s-%s", var.namespace, var.environment)].address_space
            dns_servers = var.virtual_networks[format("%s-%s", var.namespace, var.environment)].dns_servers !=null ? var.virtual_networks[format("%s-%s", var.namespace, var.environment)].dns_servers : []
            tags = {
                IaC = "Terraform"
                environment = var.environment
                module = "Networking"
                location = var.location
            }
        }
    }

}