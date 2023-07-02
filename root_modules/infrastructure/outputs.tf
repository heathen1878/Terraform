output "virtual_networks" {
  value = module.networking.virtual_network
}

output "resource_groups" {
  value = module.resource_groups.resource_group
}

output "subnets" {
  value = module.networking.subnet
}