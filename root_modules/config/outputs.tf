output "aad_applications" {
  value = {
    applications     = local.aad_applications_output
    group_membership = local.aad_applications_group_membership
  }
  sensitive = true
}

output "aad_users" {
  value = {
    users            = local.aad_users_output
    group_membership = local.aad_users_group_membership
  }
  sensitive = true
}

output "aad_groups" {
  value = local.aad_group_output
}

output "cloudflare" {
  value = {
    zones       = local.cloudflare_protected_zones
    dns_records = local.cloudflare_protected_dns_records
  }
}

output "container_groups" {
  value     = local.container_groups_output
  sensitive = true
}

output "container_registries" {
  value = local.container_registry_output
}

output "dns" {
  value = {
    zones               = local.azure_managed_zones
    dns_records         = local.azure_dns_records
    private_dns_zones   = local.private_dns_zone_outputs
    web_app_association = local.zone_and_web_app_association
  }
}

output "resource_groups" {
  value = local.resource_groups_outputs
}

output "networking" {
  value = {
    dns_resolvers                  = local.dns_resolver_output
    nat_gateways                   = local.nat_gateway_outputs
    network_watcher                = local.network_watcher_output
    nsgs                           = local.nsgs
    nsg_rules                      = local.nsg_rule_outputs
    nsg_subnet_association         = local.nsg_subnet_association_outputs
    public_ip_addresses            = local.public_ip_address_outputs
    route_tables                   = local.route_table_outputs
    route_table_subnet_association = local.route_table_associations
    routes                         = local.udr_outputs
    subnets                        = local.virtual_network_subnets_output
    virtual_networks               = local.virtual_networks_output
    virtual_network_gateways       = local.virtual_network_gateway_output
    virtual_network_peers          = local.virtual_network_peers
  }
}

output "key_vault" {
  value = local.key_vault_output
}

output "storage_accounts" {
  value = {
    accounts   = local.storage_account_output
    containers = local.storage_containers_map
  }
}

output "virtual_machines" {
  value     = local.virtual_machine_output
  sensitive = true
}

output "service_plans" {
  value = local.service_plan_output
}

output "web_apps" {
  value = {
    windows = local.windows_web_app_output
  }
}