locals {

  # For storage account configuration see here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
  storage_accounts = {
    certificates = {
      containers = {
        letsencrypt = {
          access_type = "private"
          iam = {
            container_contributor = {
              principal_id         = "1831bd6e-0648-4f14-b4f0-e020a6a67cb2"
              role_definition_name = "Storage Blob Data Contributor"
            }
          }
        }
      }
      enable_private_endpoint = true
      identity                = {}
      network_rules = {
      }
      resource_group = "frontend"
    }
    generic = {
      containers     = {}
      identity       = {}
      network_rules  = {}
      resource_group = "backend"
    }
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------

  storage_account_output = {
    for key, value in local.storage_accounts : key => {
      name                            = azurecaf_name.storage_account[key].result
      resource_group                  = value.resource_group
      location                        = local.location
      account_kind                    = lookup(value, "account_kind", "StorageV2")
      account_tier                    = lookup(value, "account_tier", "Standard")
      account_replication_type        = lookup(value, "account_replication_type", "LRS")
      allowed_copy_scope              = lookup(value, "allowed_copy_scope", null)
      allow_nested_items_to_be_public = lookup(value, "allow_nested_items_to_be_public", false)
      azure_files_authentication      = lookup(value, "azure_files_authentication", {})
      blob_properties                 = lookup(value, "blob_properties", {})
      access_tier                     = lookup(value, "access_tier", "Hot")
      container_iam = {
        for ra_key, ra_value in local.storage_container_role_assignments : ra_key => {
          container            = format("%s_%s", ra_value.storage_account_key, ra_value.container_name)
          principal_id         = ra_value.principal_id
          role_definition_name = ra_value.role_definition_name
        } if ra_value.storage_account_key == key
      }
      containers = {
        for c_key, c_value in local.storage_containers : c_key => {
          name                  = c_value.name
          container_access_type = c_value.container_access_type
        } if c_value.storage_account_key == key
      }
      cross_tenant_replication_enabled = lookup(value, "cross_tenant_replication_enabled", true)
      custom_domain                    = lookup(value, "custom_domain", {})
      customer_managed_key             = lookup(value, "customer_managed_key", {})
      default_to_oauth_authentication  = lookup(value, "default_to_oauth_authentication", false)
      edge_zone                        = lookup(value, "edge_zone", null)
      enable_https_traffic_only        = lookup(value, "enable_https_traffic_only", true)
      enable_private_endpoint          = lookup(value, "enable_private_endpoint", false)
      iam                              = lookup(value, "iam", {})
      identity = {
        type         = lookup(value.identity, "type", "SystemAssigned")
        identity_ids = lookup(value.identity, "identity_ids", [])
      }
      immutability_policy               = lookup(value, "immutability_policy", {})
      infrastructure_encryption_enabled = lookup(value, "infrastructure_encryption_enabled", false)
      is_hns_enabled                    = lookup(value, "is_hns_enabled", false)
      large_file_share_enabled          = lookup(value, "large_file_share_enabled", false)
      min_tls_version                   = lookup(value, "min_tls_version", "TLS1_2")
      network_rules = {
        bypass = lookup(value.network_rules, "bypass", [
          "None"
        ])
        default_action = lookup(value.network_rules, "default_action", "Deny")
        ip_rules = lookup(value.network_rules, "ip_rules", [
          "51.155.223.14",
          "4.158.0.0/15",
          "4.234.0.0/16",
          "4.250.0.0/16",
          "13.87.64.0/19",
          "13.87.96.0/20",
          "13.104.129.128/26",
          "13.104.145.160/27",
          "13.104.146.64/26",
          "13.104.159.0/25",
          "20.0.0.0/16",
          "20.26.0.0/16",
          "20.33.148.0/24",
          "20.33.168.0/24",
          "20.38.106.0/23",
          "20.39.208.0/20",
          "20.39.224.0/21",
          "20.47.11.0/24",
          "20.47.34.0/24",
          "20.47.68.0/24",
          "20.47.114.0/24",
          "20.49.128.0/17",
          "20.50.96.0/19",
          "20.58.0.0/18",
          "20.60.17.0/24",
          "20.60.166.0/23",
          "20.68.0.0/18",
          "20.68.128.0/17",
          "20.77.0.0/17",
          "20.77.128.0/18",
          "20.90.64.0/18",
          "20.90.128.0/17",
          "20.95.67.0/24",
          "20.95.71.0/24",
          "20.95.74.0/23",
          "20.95.82.0/23",
          "20.95.84.0/24",
          "20.95.99.0/24",
          "20.95.100.0/23",
          "20.108.0.0/16",
          "20.117.64.0/18",
          "20.117.128.0/17",
          "20.135.176.0/22",
          "20.135.180.0/23",
          "20.150.18.0/25",
          "20.150.40.0/25",
          "20.150.41.0/24",
          "20.150.69.0/24",
          "20.157.28.0/24",
          "20.157.112.0/24",
          "20.157.120.0/24",
          "20.157.157.0/24",
          "20.157.182.0/24",
          "20.157.246.0/24",
          "20.162.128.0/17",
          "20.190.143.0/25",
          "20.190.169.0/24",
          "20.202.4.0/24",
          "20.209.6.0/23",
          "20.209.30.0/23",
          "20.209.88.0/23",
          "20.209.128.0/23",
          "20.209.158.0/23",
          "20.254.0.0/17",
          "40.64.144.200/29",
          "40.64.145.16/28",
          "40.79.215.0/24",
          "40.80.0.0/22",
          "40.81.128.0/19",
          "40.90.17.32/27",
          "40.90.17.160/27",
          "40.90.29.192/26",
          "40.90.128.112/28",
          "40.90.128.160/28",
          "40.90.131.64/27",
          "40.90.139.64/27",
          "40.90.141.192/26",
          "40.90.153.64/27",
          "40.90.154.0/26",
          "40.93.67.0/24",
          "40.101.57.192/26",
          "40.101.58.0/25",
          "40.120.32.0/19",
          "40.120.136.0/22",
          "40.126.15.0/25",
          "40.126.41.0/24",
          "51.11.0.0/18",
          "51.11.128.0/18",
          "51.104.0.0/19",
          "51.104.192.0/18",
          "51.105.0.0/18",
          "51.105.64.0/20",
          "51.132.0.0/18",
          "51.132.128.0/17",
          "51.140.0.0/17",
          "51.140.128.0/18",
          "51.141.128.32/27",
          "51.141.129.64/26",
          "51.141.130.0/25",
          "51.141.135.0/24",
          "51.141.192.0/18",
          "51.142.64.0/18",
          "51.142.192.0/18",
          "51.143.128.0/18",
          "51.143.208.0/20",
          "51.143.224.0/19",
          "51.145.0.0/17",
          "52.101.88.0/23",
          "52.101.95.0/24",
          "52.101.96.0/23",
          "52.102.164.0/24",
          "52.103.37.0/24",
          "52.103.165.0/24",
          "52.108.50.0/23",
          "52.108.88.0/24",
          "52.108.99.0/24",
          "52.108.100.0/23",
          "52.109.28.0/22",
          "52.111.242.0/24",
          "52.112.231.0/24",
          "52.112.240.0/20",
          "52.113.128.0/24",
          "52.113.200.0/22",
          "52.113.204.0/24",
          "52.113.224.0/19",
          "52.114.88.0/22",
          "52.120.160.0/19",
          "52.120.240.0/20",
          "52.123.141.0/24",
          "52.123.142.0/23",
          "52.136.21.0/24",
          "52.151.64.0/18",
          "52.239.187.0/25",
          "52.239.231.0/24",
          "52.245.64.0/22",
          "52.253.162.0/23",
          "104.44.89.224/27",
          "172.165.0.0/16",
          "172.166.0.0/15",
          "172.187.128.0/17"
        ])
        virtual_network_subnet_ids = lookup(value.network_rules, "virtual_network_subnet_ids", [])
        private_link_access        = {}
      }
      nfsv3_enabled                 = lookup(value, "nfsv3_enabled", false)
      public_network_access_enabled = lookup(value, "public_network_access_enabled", true)
      queue_encryption_key_type     = lookup(value, "queue_encryption_key_type", "Service")
      queue_properties              = lookup(value, "queue_properties", {})
      routing                       = lookup(value, "routing", {})
      sas_policy                    = lookup(value, "sas_policy", {})
      sftp_enabled                  = lookup(value, "is_hns_enabled", false) == true ? true : false
      shared_access_key_enabled     = lookup(value, "shared_access_key_enabled", true)
      share_properies               = lookup(value, "share_properies", {})
      static_website                = lookup(value, "static_website", {})
      table_encryption_key_type     = lookup(value, "table_encryption_key_type", "Service")
      tags = merge(
        {
          environment = var.environment
          namespace   = var.namespace
          location    = var.location
        },
        lookup(value, "tags", {}),
        var.tags
      )
      virtual_network_subnet_private_endpoint_key = "storage"
    }
  }

  storage_containers = {
    for container in flatten([
      for key, value in local.storage_accounts : [
        for c_key, c_value in value.containers : {
          name                  = c_key
          storage_account_key   = key
          container_access_type = c_value.access_type
        }
      ] if length(value.containers) != 0
    ]) : format("%s_%s", container.storage_account_key, container.name) => container
  }

  storage_container_role_assignments = {
    for assignment in flatten([
      for key, value in local.storage_accounts : [
        for c_key, c_value in value.containers : [
          for a_key, a_value in c_value.iam : {
            storage_account_key  = key
            assignment_name      = a_key
            container_name       = c_key
            principal_id         = a_value.principal_id
            role_definition_name = a_value.role_definition_name
          } if length(a_value.principal_id) != 0
        ] if can(c_value.iam)
      ]
    ]) :
    format("%s_%s", assignment.container_name, assignment.assignment_name) => assignment
  }


}