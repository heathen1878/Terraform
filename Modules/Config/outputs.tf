output "aad_applications" {
  value     = local.aad_applications_output
  sensitive = true
}

output "aad_users" {
  value     = local.aad_users_output
  sensitive = true
}

output "aad_groups" {
  value     = local.aad_group_output
}

output "aad_application_group_membership" {
  value = local.aad_applications_group_membership_map
}

output "aad_user_group_membership" {
  value = local.aad_users_group_membership_map
}

output "virtual_network" {
    value = local.virtual_networks_output
}

output "virtual_network_subnets" {
  value = local.virtual_network_subnets_output
}

output "subnets_with_nsgs_map" {
    value = local.subnetsWithNsgs_map
}

output "nsg_rules_map" {
    value = local.nsgRules_map
}

output "key_vaults" {
    value = local.key_vault_outputs
}

output "virtual_machine_resource_group" {
  value = azurecaf_name.vm_resource_group.result
}

output "virtual_machines" {
    value = local.virtual_machine_output
    sensitive = true
}