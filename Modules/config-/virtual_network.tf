locals {

  # Uses the address_space attribute from virtual_networks_output to generate a subnet address prefix e.g. 
  # where the address space is 10.0.0.0/16 the subnet size of 10 with an octet of zero will result in 10.0.0.0/26.
  # The address space block attribute determines which block of address space is used e.g. a virtual network with more than one block would
  # be 0 for the first block, then 1 for the next block and so on. The virtual network is defined within tfvars - see variables.tf for the defaults.
  virtual_network_subnets = {
    default = {
      address_space_block = 0
      delegations         = {}
      octet               = 0
      subnet_size         = 5
    }
    Containers = {
      address_space_block = 1
      delegations = {
        aci = {
          name = "aci"
          service_delegation = {
            name = "Microsoft.ContainerInstance/containerGroups"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/action"
            ]
          }
        }
      }
      octet       = 6
      subnet_size = 4
    }
    Databases = {
      address_space_block = 1
      delegations         = {}
      octet               = 3
      subnet_size         = 5
    }
    Webs = {
      address_space_block = 1
      delegations         = {}
      octet               = 4
      subnet_size         = 5
    }
    FunctionApps = {
      address_space_block = 1
      delegations         = {}
      octet               = 5
      subnet_size         = 5
    }
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------

  network_watcher_output = {
    format("nw_%s_%s_%s", var.namespace, var.environment, local.location) = {
      name                = format("nw-%s-%s-%s", var.namespace, var.environment, local.location)
      resource_group_name = "management"
    }
  }

  virtual_networks_output = {
    format("%s_%s_%s", var.namespace, var.environment, local.location) = {
      name                = format("vnet-%s-%s-%s", var.namespace, var.environment, local.location)
      resource_group_name = "management"
      location            = var.location
      address_space       = var.virtual_networks[format("%s-%s-%s", var.namespace, var.environment, local.location)].address_space
      dns_servers         = var.virtual_networks[format("%s-%s-%s", var.namespace, var.environment, local.location)].dns_servers != null ? var.virtual_networks[format("%s-%s-%s", var.namespace, var.environment, local.location)].dns_servers : []
      tags = {
        IaC         = "Terraform"
        environment = var.environment
        module      = "Networking"
        location    = var.location
      }
    }
  }

  virtual_network_subnets_output = {
    subnets = local.virtual_network_subnets
  }

  subnets_with_nsgs = flatten(
    [
      for subnet_key, rule_values in var.nsg_rules : [
        {
          nsg_name = lower(azurecaf_name.network_security_group[subnet_key].result)
          subnet   = subnet_key
        }
      ]
    ]
  )

  nsg_rules = flatten(
    [
      for subnet_key, rule_values in var.nsg_rules : [
        for rule_key, rules in rule_values : {
          nsg_name                     = lower(azurecaf_name.network_security_group[subnet_key].result)
          subnet                       = subnet_key
          ruleId                       = rule_key
          name                         = rules.name
          priority                     = rules.priority
          protocol                     = rules.protocol
          direction                    = rules.direction
          access                       = rules.access
          description                  = rules.description == "" ? null : rules.description
          source_port_range            = rules.source_port_range == "" ? null : rules.source_port_range
          source_port_ranges           = length(rules.source_port_ranges) == 0 ? null : rules.source_port_ranges
          destination_port_range       = rules.destination_port_range == "" ? null : rules.destination_port_range
          destination_port_ranges      = length(rules.destination_port_ranges) == 0 ? null : rules.destination_port_ranges
          source_address_prefix        = rules.source_address_prefix == "" ? null : rules.source_address_prefix
          source_address_prefixes      = length(rules.source_address_prefixes) == 0 ? null : rules.source_address_prefixes
          destination_address_prefix   = rules.destination_address_prefix == "" ? null : rules.destination_address_prefix
          destination_address_prefixes = length(rules.destination_address_prefixes) == 0 ? null : rules.destination_address_prefixes
        }
      ]
    ]
  )

  nsg_rules_map = {
    for nsg_rules_key, nsg_rules_value in local.nsg_rules :
    lower(format("%s_%s", nsg_rules_value.subnet, nsg_rules_value.ruleId)) => nsg_rules_value
  }

  subnets_with_nsgs_map = {
    for nsg_subnet_key, nsg_subnet_value in local.subnets_with_nsgs :
    lower(format("%s_%s", nsg_subnet_value.nsg_name, nsg_subnet_value.subnet)) => nsg_subnet_value
  }

}
