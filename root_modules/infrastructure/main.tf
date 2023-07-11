module "resource_groups" {
  source  = "heathen1878/resource-groups/azurerm"
  version = "1.0.1"

  resource_groups = data.terraform_remote_state.config.outputs.resource_groups
}

module "networking" {
  source  = "heathen1878/networking/azurerm"
  version = "1.0.0"

  network_watcher       = local.network_watcher
  virtual_networks      = local.virtual_network
  virtual_network_peers = local.virtual_network_peers
  subnets               = local.subnets
  public_ip_addresses   = local.public_ip_addresses
  nat_gateways          = local.nat_gateways
  route_tables          = local.route_tables
  routes                = local.routes
  nsgs                  = local.nsgs
  nsg_rules             = data.terraform_remote_state.config.outputs.networking.nsg_rules
  nsg_association       = data.terraform_remote_state.config.outputs.networking.nsg_subnet_association
}

module "dns" {
  source  = "heathen1878/dns/azurerm"
  version = "1.0.1"

  private_dns_zones = local.private_dns_zones
  public_dns_zones  = local.public_dns_zones
}

module "key_vaults" {
  for_each = local.key_vaults

  source  = "heathen1878/key-vault/azurerm"
  version = "1.0.0"

  name                                       = each.value.name
  location                                   = each.value.location
  resource_group_name                        = each.value.resource_group_name
  enable_private_endpoint                    = each.value.enable_private_endpoint
  enable_rbac_authorization                  = each.value.enable_rbac_authorization
  iam                                        = each.value.iam
  network_acls                               = each.value.network_acls
  public_network_access_enabled              = each.value.public_network_access_enabled
  sku_name                                   = each.value.sku_name
  soft_delete_retention_days                 = each.value.soft_delete_retention_days
  tags                                       = each.value.tags
  tenant_id                                  = each.value.tenant_id
  virtual_network_subnet_private_endpoint_id = each.value.virtual_network_subnet_private_endpoint_id
}

module "storage_accounts" {
  for_each = local.storage_accounts

  source  = "heathen1878/storage/azurerm"
  version = "1.0.0"

  name                                       = each.value.name
  location                                   = each.value.location
  resource_group_name                        = each.value.resource_group_name
  account_replication_type                   = each.value.account_replication_type
  account_tier                               = each.value.account_tier
  allow_nested_items_to_be_public            = each.value.allow_nested_items_to_be_public
  allowed_copy_scope                         = each.value.allowed_copy_scope
  azure_files_authentication                 = each.value.azure_files_authentication
  blob_properties                            = each.value.blob_properties
  cross_tenant_replication_enabled           = each.value.cross_tenant_replication_enabled
  container_iam                              = each.value.container_iam
  containers                                 = each.value.containers
  custom_domain                              = each.value.custom_domain
  customer_managed_key                       = each.value.customer_managed_key
  default_to_oauth_authentication            = each.value.default_to_oauth_authentication
  edge_zone                                  = each.value.edge_zone
  enable_https_traffic_only                  = each.value.enable_https_traffic_only
  enable_private_endpoint                    = each.value.enable_private_endpoint
  iam                                        = each.value.iam
  identity                                   = each.value.identity
  immutability_policy                        = each.value.immutability_policy
  infrastructure_encryption_enabled          = each.value.infrastructure_encryption_enabled
  is_hns_enabled                             = each.value.is_hns_enabled
  large_file_share_enabled                   = each.value.large_file_share_enabled
  min_tls_version                            = each.value.min_tls_version
  network_rules                              = each.value.network_rules
  nfsv3_enabled                              = each.value.nfsv3_enabled
  private_dns_zone_ids                       = each.value.private_dns_zone_ids
  public_network_access_enabled              = each.value.public_network_access_enabled
  queue_encryption_key_type                  = each.value.queue_encryption_key_type
  queue_properties                           = each.value.queue_properties
  routing                                    = each.value.routing
  sas_policy                                 = each.value.sas_policy
  sftp_enabled                               = each.value.sftp_enabled
  share_properies                            = each.value.share_properies
  shared_access_key_enabled                  = each.value.shared_access_key_enabled
  static_website                             = each.value.static_website
  table_encryption_key_type                  = each.value.table_encryption_key_type
  tags                                       = each.value.tags
  virtual_network_subnet_private_endpoint_id = each.value.virtual_network_subnet_private_endpoint_id
}

locals {

  network_watcher = {
    for key, value in data.terraform_remote_state.config.outputs.networking.network_watcher : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      location            = value.location
      tags                = value.tags
      use_existing        = value.use_existing
    }
  }

  virtual_network = {
    for key, value in data.terraform_remote_state.config.outputs.networking.virtual_networks : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      location            = value.location
      address_space       = value.address_space
      dns_servers         = value.dns_servers
      tags                = value.tags
    }
  }

  virtual_network_peers = {
    for key, value in data.terraform_remote_state.config.outputs.networking.virtual_network_peers : key => {
      peer_1_id   = value.peer_1_id
      peer_1_rg   = value.peer_1_rg
      peer_1_name = value.peer_1_name
      peer_2_id   = value.peer_2_id
    }
  }

  subnets = {
    for key, value in data.terraform_remote_state.config.outputs.networking.subnets : key => {
      name                = value.name
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      virtual_network_key = value.virtual_network_key
      address_prefixes = [
        value.address_space
      ]
      delegation                                    = value.delegations
      private_endpoint_network_policies_enabled     = value.private_endpoint_network_policies_enabled
      private_link_service_network_policies_enabled = value.private_link_service_network_policies_enabled
      service_endpoints                             = value.service_endpoints
      service_endpoint_policy_ids                   = value.service_endpoint_policy != false ? [] : null # TODO: work out how to dynamically get Ids if this is true.
      enable_nat_gateway                            = value.enable_nat_gateway
      nat_gateway_key                               = value.nat_gateway_key
    }
  }

  nat_gateways = {
    for key, value in data.terraform_remote_state.config.outputs.networking.nat_gateways : key => {
      name                    = value.name
      resource_group_name     = module.resource_groups.resource_group[value.resource_group].name
      location                = value.location
      idle_timeout_in_minutes = value.idle_timeout_in_minutes
      sku_name                = value.sku_name
      tags                    = value.tags
      zones                   = value.zones
    }
  }

  public_ip_addresses = {
    for key, value in data.terraform_remote_state.config.outputs.networking.public_ip_addresses : key => {
      name                    = value.name
      resource_group_name     = module.resource_groups.resource_group[value.resource_group].name
      location                = value.location
      allocation_method       = value.allocation_method
      ddos_protection_mode    = value.ddos_protection_mode
      ddos_protection_plan_id = value.ddos_protection_plan == true ? "plan_id" : null # TODO: work out what this actually does
      domain_name_label       = value.domain_name_label
      edge_zone               = value.edge_zone # TODO: work out what this actually does
      idle_timeout_in_minutes = value.idle_timeout_in_minutes
      ip_version              = value.ip_version
      ip_tags                 = value.ip_tags
      public_ip_prefix_id     = value.public_ip_prefix == true ? "prefix_id" : null
      reverse_fqdn            = value.reverse_fqdn
      sku                     = value.sku
      sku_tier                = value.sku_tier
      tags                    = value.tags
      zones                   = value.zones
    }
  }

  route_tables = {
    for key, value in data.terraform_remote_state.config.outputs.networking.route_tables : key => {
      name                          = value.name
      location                      = value.location
      resource_group_name           = module.resource_groups.resource_group[value.resource_group].name
      disable_bgp_route_propagation = value.disable_bgp_route_propagation
      tags                          = value.tags
    }
  }

  routes = {
    for key, value in data.terraform_remote_state.config.outputs.networking.routes : key => {
      name                   = value.name
      resource_group_name    = module.resource_groups.resource_group[value.resource_group].name
      route_table_key        = value.route_table_key
      address_prefix         = value.address_prefix
      next_hop_type          = value.next_hop_type
      next_hop_in_ip_address = "10.10.0.10" # TODO: this needs to be a lookup if the next hop type is virtual appliance.
    }
  }

  nsgs = {
    for key, value in data.terraform_remote_state.config.outputs.networking.nsgs : key => {
      name                = value.name
      location            = value.location
      resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      tags                = value.tags
    }
  }

  private_dns_zones = {
    for key, value in data.terraform_remote_state.config.outputs.dns.private_dns_zones : key => {
      name                 = value.name
      resource_group_name  = module.resource_groups.resource_group[value.resource_group].name
      tags                 = value.tags
      virtual_network_name = module.networking.virtual_network["environment"].name
      virtual_network_id   = module.networking.virtual_network["environment"].id
    }
  }

  public_dns_zones = {
    for key, value in data.terraform_remote_state.config.outputs.dns.subdomains : key => {
      name                          = data.terraform_remote_state.global_dns_zones.outputs.dns.zones.azure[value.name].name
      resource_group_name           = data.terraform_remote_state.global_dns_zones.outputs.dns.zones.azure[value.name].resource_group_name
      subdomain                     = value.subdomain
      subdomain_resource_group_name = module.resource_groups.resource_group[value.resource_group].name
      ttl                           = value.ttl
      tags                          = value.tags
    }
  }

  key_vaults = {
    for key, value in data.terraform_remote_state.config.outputs.key_vault : key => {
      name                      = value.name
      location                  = value.location
      resource_group_name       = module.resource_groups.resource_group[value.resource_group].name
      enable_private_endpoint   = value.enable_private_endpoint
      enable_rbac_authorization = value.enable_rbac_authorization
      iam                       = value.iam
      network_acls              = value.network_acls
      private_dns_zone_ids = [
        module.dns.private_dns_zones["key_vault"].id
      ]
      public_network_access_enabled              = value.public_network_access_enabled
      sku_name                                   = value.sku_name
      soft_delete_retention_days                 = value.soft_delete_retention_days
      tags                                       = value.tags
      tenant_id                                  = value.tenant_id
      virtual_network_subnet_private_endpoint_id = module.networking.subnet[value.virtual_network_subnet_private_endpoint_key].id
    }
  }

  key_vault_outputs = {
    for key, value in data.terraform_remote_state.config.outputs.key_vault : key => {
      output = module.key_vaults[key].key_vault
    }
  }

  storage_accounts = {
    for key, value in data.terraform_remote_state.config.outputs.storage_accounts : key => {
      access_tier                       = value.access_tier
      account_kind                      = value.account_kind
      account_replication_type          = value.account_replication_type
      account_tier                      = value.account_tier
      allow_nested_items_to_be_public   = value.allow_nested_items_to_be_public
      allowed_copy_scope                = value.allowed_copy_scope
      azure_files_authentication        = value.azure_files_authentication
      blob_properties                   = value.blob_properties
      cross_tenant_replication_enabled  = value.cross_tenant_replication_enabled
      container_iam                     = value.container_iam
      containers                        = value.containers
      custom_domain                     = value.custom_domain
      customer_managed_key              = value.customer_managed_key
      default_to_oauth_authentication   = value.default_to_oauth_authentication
      edge_zone                         = value.edge_zone
      enable_https_traffic_only         = value.enable_https_traffic_only
      enable_private_endpoint           = value.enable_private_endpoint
      iam                               = value.iam
      identity                          = value.identity
      immutability_policy               = value.immutability_policy
      infrastructure_encryption_enabled = value.infrastructure_encryption_enabled
      is_hns_enabled                    = value.is_hns_enabled
      large_file_share_enabled          = value.large_file_share_enabled
      location                          = value.location
      min_tls_version                   = value.min_tls_version
      name                              = value.name
      network_rules                     = value.network_rules
      nfsv3_enabled                     = value.nfsv3_enabled
      private_dns_zone_ids = [
        module.dns.private_dns_zones["blob_core_windows"].id
      ]
      public_network_access_enabled              = value.public_network_access_enabled
      queue_encryption_key_type                  = value.queue_encryption_key_type
      queue_properties                           = value.queue_properties
      resource_group_name                        = module.resource_groups.resource_group[value.resource_group].name
      routing                                    = value.routing
      sas_policy                                 = value.sas_policy
      sftp_enabled                               = value.sftp_enabled
      share_properies                            = value.share_properies
      shared_access_key_enabled                  = value.shared_access_key_enabled
      static_website                             = value.static_website
      table_encryption_key_type                  = value.table_encryption_key_type
      tags                                       = value.tags
      virtual_network_subnet_private_endpoint_id = module.networking.subnet[value.virtual_network_subnet_private_endpoint_key].id
    }
  }

  storage_accounts_outputs = {
    for key, value in data.terraform_remote_state.config.outputs.storage_accounts : key => {
      output = module.storage_accounts[key].storage_account
    }
  }

}