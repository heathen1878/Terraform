output "aad_applications" {
  value     = {
    applications = local.aad_applications_output
    group_membership = local.aad_applications_group_membership
  }
  sensitive = true
}

output "aad_users" {
  value     = {
    users = local.aad_users_output
    group_membership = local.aad_users_group_membership
  }
  sensitive = true
}

output "aad_groups" {
  value = local.aad_group_output
}


output "container_groups" {
  value     = local.container_groups_output
  sensitive = true
}

output "container_registries" {
  value = local.container_registry_output
}

output "resource_groups" {
  value = local.resource_groups_outputs
}

output "network_watcher" {
  value = local.network_watcher_output
}

output "virtual_network" {
  value = local.virtual_networks_output
}

output "virtual_network_subnets" {
  value = local.virtual_network_subnets_output
}

output "subnets_with_nsgs_map" {
  value = local.subnets_with_nsgs_map
}

output "nsg_rules_map" {
  value = local.nsg_rules_map
}

output "key_vaults" {
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

output "windows_web_app_plans" {
  value = local.windows_web_app_plan_output
}

output "windows_web_app" {
  value = local.windows_web_app_output
}

