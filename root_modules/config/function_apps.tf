locals {

  windows_function_apps = merge(var.windows_function_apps, {})

  windows_function_app_output = {
    for key, value in local.windows_function_apps : key => {
      name           = format("func-%s", azurecaf_name.windows_function_app[key].result)
      resource_group = value.resource_group
      location       = var.location
      service_plan   = value.sku == "Y1" ? local.consumption_service_plan_output[key].name : local.premium_service_plan_output[value.sku].name
      site_config = {
        always_on                = lookup(value.site_config, "always_on", false)
        api_definition_url       = lookup(value.site_config, "api_defnition_url", null)
        api_management_api_id    = lookup(value.site_config, "api_management_api_id", null)
        app_command_line         = lookup(value.site_config, "app_command_line", null)
        app_scale_limit          = lookup(value, "app_scale_limit", 1)
        application_insights_key = lookup(value, "application_insights_key", null)
        application_stack = {
          dotnet_version              = lookup(value.site_config.application_stack, "dotnet_version", "v4.0")
          use_dotnet_isolated_runtime = lookup(value.site_config.application_stack, "use_dotnet_isolated_runtime", false)
          java_version                = lookup(value.site_config.application_stack, "java_version", "17.0.2")
          node_version                = lookup(value.site_config.application_stack, "node_version", "~18")
          powershell_core_version     = lookup(value.site_config.application_stack, "powershell_core_version", "7")
          use_custom_runtime          = lookup(value.site_config.application_stack, "use_custom_runtime", false)
        }
        app_service_logs = {
          disk_quota_mb         = lookup(value.site_config.app_service_logs, "disk_quota_mb", 35)
          retention_period_days = lookup(value.site_config.app_service_logs, "retention_period_days", 0)
        }
        cors = {
          allowed_origins     = lookup(value.site_config, "cors.allowed_origins", [])
          support_credentials = lookup(value.site_config, "cors.support_credentials", false)
        }
        default_documents = lookup(value.site_config, "default_documents", [
          "Default.htm",
          "Default.html",
          "Default.asp",
          "index.htm",
          "index.html",
          "iisstart.htm",
          "default.aspx",
          "index.php",
          "hostingstart.html"
        ])
        elastic_instance_minimum          = contains(["EP1", "EP2", "EP3"], value.sku) ? 1 : null
        ftps_state                        = lookup(value.site_config, "ftps_state", "Disabled")
        health_check_path                 = lookup(value.site_config, "health_check_path", "")
        health_check_eviction_time_in_min = lookup(value.site_config, "health_check_eviction_time_in_min", 10)
        http2_enabled                     = lookup(value.site_config, "http2_enabled", false)
        ip_restriction                    = lookup(value.site_config, "ip_restriction", [])
        load_balancing_mode               = lookup(value.site_config, "load_balancing_mode", "LeastRequests")
        managed_pipeline_mode             = lookup(value.site_config, "managed_pipeline_mode", "Integrated")
        minimum_tls_version               = lookup(value.site_config, "minimum_tls_version", "1.2")
        pre_warmed_instance_count         = contains(["EP1", "EP2", "EP3"], value.sku) ? 1 : null
        remote_debugging_enabled          = lookup(value.site_config, "remote_debugging_enabled", false)
        remote_debugging_version          = lookup(value.site_config, "remote_debugging_version", "VS2019")
        runtime_scale_monitoring          = contains(["EP1", "EP2", "EP3"], value.sku) ? true : false
        scm_ip_restriction                = lookup(value.site_config, "ip_restriction", [])
        scm_minimum_tls_version           = lookup(value.site_config, "minimum_tls_version", "1.2")
        scm_use_main_ip_restriction       = lookup(value.site_config, "scm_use_main_ip_restriction", false)
        use_32_bit_worker                 = lookup(value.site_config, "use_32_bit_worker", true)
        vnet_route_all_enabled            = lookup(value, "virtual_network_subnet_integration_subnet_key", null) != null ? true : false
        websockets_enabled                = lookup(value.site_config, "websockets_enabled", false)
        worker_count                      = lookup(value.site_config, "worker_count", 1)
      }
      auth_settings = {
        enabled = lookup(value.auth_settings, "enabled", false)
      }
      auth_settings_v2 = {
      }
      app_settings = lookup(value, "app_settings", {
      })
      backup = {
        enabled = lookup(value.backup, "enabled", false)
        name    = lookup(value.backup, "name", "custom backups")
        schedule = {
          frequency_interval       = lookup(value.backup.schedule, "interval", 1)
          frequency_unit           = lookup(value.backup.schedule, "unit", "Day")
          keep_at_least_one_backup = lookup(value.backup.schedule, "retain", true)
          retention_period_days    = lookup(value.backup.schedule, "retention_in_days", 30)
          start_time               = lookup(value.backup.schedule, "start", "")
        }
        storage_account_url = lookup(value.backup, "storage_account_key", "")
      }
      builtin_logging_enabled            = lookup(value, "builtin_logging_enabled", true)
      client_certificate_enabled         = lookup(value, "client_certificate_enabled", false)
      client_certificate_mode            = lookup(value, "client_certificate_mode", "Required")
      client_certificate_exclusion_paths = lookup(value, "client_certificate_exclusion_paths", "")
      connection_string = {
        name  = lookup(value.connection_string, "name", null)
        type  = lookup(value.connection_string, "type", null)
        value = lookup(value.connection_string, "value", null)
      }
      content_share_force_disabled = lookup(value, "content_share_force_disabled", false)
      daily_memory_time_quota      = value.sku == "Y1" ? 0 : null
      deploy_slot                  = lookup(value, "deploy_slot", true)
      enabled                      = lookup(value, "enabled", true)
      enable_private_endpoint      = lookup(value, "enable_private_endpoint", false)
      functions_extension_version  = lookup(value, "functions_extension_version", "~4")
      https_only                   = lookup(value, "https_only", true)
      identity = {
        type         = lookup(value.identity, "type", "SystemAssigned")
        identity_ids = []
      }
      key_vault_reference_identity_id = lookup(value, "key_vault_reference_identity_id", null)
      sticky_settings = {
        app_setting_names       = lookup(value.sticky_settings, "app_setting_names", null)
        connection_string_names = lookup(value.sticky_settings, "connection_string_names", null)
      }
      storage_account = {
        access_key   = "Grab dynamically using storage account outputs"
        account_name = lookup(value.storage_account, "storage_account_key", null)
        name         = lookup(value.storage_account, "name", null)
        share_name   = lookup(value.storage_account, "share_name", null)
        type         = lookup(value.storage_account, "type", "AzureBlob")
        mount_path   = lookup(value.storage_account, "mount_path", null)
      }
      storage_account_name          = azurecaf_name.windows_function_app_storage[key].result
      storage_uses_managed_identity = lookup(value, "storage_uses_managed_identity", true)
      tags = merge(
        {
          environment = var.environment
          namespace   = var.namespace
          location    = var.location
        },
        lookup(value, "tags", {}),
        var.tags
      )
      virtual_network_subnet_private_endpoint_key   = lookup(value, "virtual_network_subnet_private_endpoint_key", "function_apps_frontend")
      virtual_network_subnet_integration_subnet_key = lookup(value, "virtual_network_subnet_integration_subnet_key", null)
      zip_deploy_file                               = lookup(value, "zip_deploy_file", null)
    }
  }

}