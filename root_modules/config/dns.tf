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
      resource_group = lookup(value, "resource_group", "environment")
      tags = {
        IaC         = "Terraform"
        environment = var.environment
        namespace   = var.namespace
      }
    }
  }

  azure_dns_subdomains = {
    for key, value in var.dns_records : key => {
      name           = value.zone_key
      subdomain      = var.environment != "prd" ? format("%s.%s", var.environment, replace(value.zone_key, "_", ".")) : null
      resource_group = lookup(value, "resource_group", "environment")
      ttl            = 3600
      tags = merge(
        {
          environment = var.environment
          namespace   = var.namespace
          location    = var.location
        },
        lookup(value, "tags", {}),
        var.tags
      )
    } if value.azure_managed == true && key == "apex"
  }

  azure_dns_records = {
    for key, value in var.dns_records : key => {
      type = value.type
      ttl  = value.ttl
      zone = value.zone_key
    } if value.azure_managed == true && value.associated_web_app == null
  }

  cloudflare_protected_dns_records = {
    for key, value in var.dns_records : key => {
      associated_web_app = value.associated_web_app
      type               = value.type
      ttl                = value.proxy_status == true ? 1 : value.ttl
      proxied            = value.proxy_status
      zone               = value.zone_key
    } if value.cloudflare_protected == true && value.associated_web_app == null
  }

  certificate_name = {
    for key, value in data.terraform_remote_state.global_config.outputs.domain_names : key => {
      name           = var.environment == "prd" ? format("wildcard-%s", replace(value.name, ".", "-")) : format("wildcard-%s-%s", var.environment, replace(value.name, ".", "-"))
      resource_group = "frontend"
    }
  }

}