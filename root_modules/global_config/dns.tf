locals {

  # Private zone names can be found here: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration
  private_dns_zones = {
    azure_automation = {
      name = "privatelink.azure-automation.net"
    }
    database_windows   = {}
    blob_core_windows  = {}
    table_core_windows = {}
    queue_core_windows = {}
    file_core_windows  = {}
    web_core_windows   = {}
    key_vault = {
      name = "privatelink.vaultcore.azure.net"
    }
    search_windows      = {}
    servicebus          = {}
    azurewebsites       = {}
    scm_azurewebsites   = {}
    redis_cache_windows = {}
  }

  private_dns_zone_outputs = {
    for key, value in local.private_dns_zones : key => {
      name           = lookup(value, "name", format("privatelink.%s.net", replace(key, "_", ".")))
      resource_group = lookup(value, "resource_group", "global")
    }
  }

}