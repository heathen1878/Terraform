output "dns" {
  value = {
    zones = {
      public  = module.dns.public_dns_zones
      private = module.dns.private_dns_zones
    }
  }
}

output "key_vault" {
  value = local.key_vault_outputs
}

output "resource_groups" {
  value = module.resource_groups.resource_group
}

output "storage_account" {
  value = local.storage_accounts_outputs
}

output "subnets" {
  value = module.networking.subnet
}

output "virtual_networks" {
  value = module.networking.virtual_network
}