output "aad_applications" {
  value = {
    applications     = local.aad_applications_output
    group_membership = local.aad_applications_group_membership
  }
  sensitive = true
}

output "aad_groups" {
  value = local.aad_group_output
}

output "aad_users" {
  value = {
    users            = local.aad_users_output
    group_membership = local.aad_users_group_membership
  }
  sensitive = true
}

output "azdo_projects" {
  value = local.azdo_projects_output
}

output "azdo_repos" {
  value = local.azdo_project_repositories_output
}

output "container_groups" {
  value     = local.container_groups_output
  sensitive = true
}

output "container_registries" {
  value = local.container_registry_output
}

output "dns_resolver" {
  value = local.dns_resolver_output
}

#output "azure_service_tags" {
#  value = {
#    frontdoor_backend = local.azure_frontdoor_backend
#  }
#}

output "key_vaults" {
  value = local.key_vault_output
}

output "network_watcher" {
  value = local.network_watcher_output
}

output "resource_groups" {
  value = local.resource_groups_outputs
}

output "virtual_network" {
  value = local.virtual_networks_output
}

output "virtual_network_gateway" {
  value = local.virtual_network_gateway_output
}

output "virtual_network_subnets" {
  value = local.virtual_network_subnets_output
}

output "subnets_with_nsgs_map" {
  value = local.subnets_with_nsgs_output
}

output "nsg_rules_map" {
  value = local.nsg_rules_output
}
