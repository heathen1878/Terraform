locals {

    # Uses the address_space attribute from virtual_networks_output to generate a subnet address prefix e.g. 
    # where the address space is 10.0.0.0/16 the subnet size of 10 with an octet of zero will result in 10.0.0.0/26.
    # The address space block attribute determines which block of address space is used e.g. a virtual network with more than one block would
    # be 0 for the first block, then 1 for the next block and so on. The virtual network is defined within tfvars.
    virtual_network_subnets = {
        GatewaySubnet = {
            subnet_size = 10
            address_space_block = 0
            octet = 0
        }
        Workstations = {
            subnet_size = 8
            address_space_block = 1
            octet = 2
        }
        Databases = {
            subnet_size = 8
            address_space_block = 0
            octet = 3
        }
        Webs = {
            subnet_size = 8
            address_space_block = 0
            octet = 4
        }
        FunctionApps = {
            subnet_size = 8
            address_space_block = 0
            octet = 5
        }
    }

    # ---------------------------------------------------------------------------------------------------------------------
    # LOCAL CALCULATED
    # ---------------------------------------------------------------------------------------------------------------------
    
    virtual_networks_output = {
        format("%s_%s", var.namespace, var.environment) = {
            name = azurecaf_name.virtual_network.result
            resource_group_name = azurecaf_name.net_resource_group.result
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

    virtual_network_subnets_output = {
        subnets = local.virtual_network_subnets
    }

}