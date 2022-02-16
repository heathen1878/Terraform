locals {
    subnetsWithNsgs = flatten(
        [
            for subnet_key, rule_values in var.nsgRules : [
                {
                    nsgName = lower(format("%s-%s", azurecaf_name.networkSecurityGroup.result, subnet_key))
                    subnet = subnet_key
                }
            ]    
        ]
    )

    subnetsWithNsgs_map = {
        for nsg_subnet_key, nsg_subnet_value in local.subnetsWithNsgs : 
            lower(format("%s_%s", nsg_subnet_value.nsgName, nsg_subnet_value.subnet)) => nsg_subnet_value
    }

    nsgRules = flatten(
        [
            for subnet_key, rule_values in var.nsgRules : [
                for rule_key, rules in rule_values : {
                    subnet = subnet_key
                    ruleId = rule_key
                    name = rules.name
                    priority = rules.priority
                    protocol = rules.protocol
                    direction = rules.direction
                    access = rules.access
                    description = rules.description == "" ? null : rules.description
                    source_port_range = rules.source_port_range == "" ? null : rules.source_port_range
                    source_port_ranges = length(rules.source_port_ranges) == 0 ? null : rules.source_port_ranges
                    destination_port_range = rules.destination_port_range == "" ? null : rules.destination_port_range
                    destination_port_ranges = length(rules.destination_port_ranges) == 0 ? null : rules.destination_port_ranges
                    source_address_prefix = rules.source_address_prefix == "" ? null : rules.source_address_prefix
                    source_address_prefixes = length(rules.source_address_prefixes) == 0 ? null : rules.source_address_prefixes
                    destination_address_prefix = rules.destination_address_prefix == "" ? null : rules.destination_address_prefix
                    destination_address_prefixes = length(rules.destination_address_prefixes) == 0 ? null : rules.destination_address_prefixes
                }
            ]
        ]
    )

    nsgRules_map = {
        for nsg_rules_key, nsg_rules_value in local.nsgRules : 
            lower(format("%s_%s", nsg_rules_value.subnet, nsg_rules_value.ruleId)) => nsg_rules_value
    }

    

}

