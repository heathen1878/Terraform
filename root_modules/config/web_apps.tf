locals {

  windows_web_apps = {
    demo = {
      name           = "demo"
      resource_group = "demo"
    }
  }

  windows_web_app_output = {
    for key, value in local.windows_web_apps : key => {
      name           = azurecaf_name.windows_web_app[key].result
      resource_group = lookup(value, "resource_group", "demo")
      location       = var.location
      service_plan   = lookup(value, "app_plan", "default")
      site_config = {
        always_on             = lookup(value, "site_config.always_on", false)
        api_definition_url    = lookup(value, "site_config.api_defnition_url", null)
        api_management_api_id = lookup(value, "site_config.api_management_api_id", null)
        app_command_line      = lookup(value, "site_config.app_command_line", null)
        application_stack = {
          current_stack       = lookup(value, "site_config.application_stack.current_stack", "dotnet")
          dotnet_version      = lookup(value, "site_config.application_stack.dotnet_version", "v4.0")
          dotnet_core_version = lookup(value, "site_config.application_stack.dotnet_core_version", "v4.0")
          node_version        = lookup(value, "site_config.application_stack.node_version", "~18")
          python              = lookup(value, "site_config.application_stack.python", false)
          php_version         = lookup(value, "site_config.application_stack.php_version", "Off")
          java_version        = lookup(value, "site_config.application_stack.java_version", "17.0.2")
          tomcat_version      = lookup(value, "site_config.application_stack.tomcat_version", "10.0.20")
        }
        auto_heal_enabled = lookup(value, "site_config.auto_heal_enabled", false)
        #auto_heal_setting = {
        #  action = lookup(value.)
        #  trigger = lookup(value.site_config.auto_heal_setting, "trigger", )
        #}
        container_registry_managed_identity_client_id = lookup(value, "site_config.container_registry_managed_identity_client_id", "")
        container_registry_use_managed_identity       = lookup(value, "site_config.container_registry_use_managed_identity", false)
        cors = {
          allowed_origins     = lookup(value, "site_config.cors.allowed_origins", [])
          support_credentials = lookup(value, "site_config.cors.support_credentials", false)
        }
        default_documents = lookup(value, "site_config.default_documents", [
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
        ftps_state                        = lookup(value, "site_config.ftps_state", "FtpsOnly")
        health_check_path                 = lookup(value, "site_config.health_check_path", "")
        health_check_eviction_time_in_min = lookup(value, "site_config.health_check_eviction_time_in_min", 10)
        http2_enabled                     = lookup(value, "site_config.http2_enabled", false)
        ip_restriction = lookup(value, "site_config.ip_restriction", [
          "0.0.0.0/0"
        ])
        load_balancing_mode      = lookup(value, "site_config.load_balancing_mode", "LeastRequests")
        local_mysql_enabled      = lookup(value, "site_config.mysql_enabled", false)
        managed_pipeline_mode    = lookup(value, "site_config.managed_pipeline_mode", "Integrated")
        minimum_tls_version      = lookup(value, "site_config.minimum_tls_version", "1.2")
        remote_debugging_enabled = lookup(value, "site_config.remote_debugging_enabled", false)
        remote_debugging_version = lookup(value, "site_config.remote_debugging_version", "VS2019")
        scm_ip_restriction = lookup(value, "site_config.ip_restriction", [
          "0.0.0.0/0"
        ])
        scm_minimum_tls_version     = lookup(value, "site_config.minimum_tls_version", "1.2")
        scm_type                    = lookup(value, "site_config.scm_type", "None")
        scm_use_main_ip_restriction = lookup(value, "site_config.scm_use_main_ip_restriction", false)
        use_32_bit_worker           = lookup(value, "site_config.use_32_bit_worker", true)
        virtual_application = {
          physical_path = lookup(value, "site_config.virtual_application.physical_path", null)
          preload       = lookup(value, "site_config.virtual_application.preload", null)
          virtual_directory = {
            physical_path = lookup(value, "site_config.virtual_application.virtual_directory.physical_path", null)
            virtual_path  = lookup(value, "site_config.virtual_application.virtual_directory.virtual_path", null)
          }
          virtual_path = lookup(value, "site_config.virtual_application.virtual_path", null)
        }
        vnet_route_all_enabled = lookup(value, "site_config.vnet_route_all_enabled", false)
        websockets_enabled     = lookup(value, "site_config.websockets_enabled", false)
        worker_count           = lookup(value, "site_config.worker_count", 1)
      }
      auth_settings = {
        enabled = lookup(value, "auth_settings.enabled", false)
      }
      auth_settings_v2 = {}
      app_settings = lookup(value, "app_settings", {
      })
      backup = {
        enabled = lookup(value, "backup.enabled", false)
        name    = lookup(value, "backup.name", "custom backups")
        schedule = {
          frequency_interval       = lookup(value, "backup.schedule.interval", null)
          frequency_unit           = lookup(value, "backup.schedule.unit", null)
          keep_at_least_one_backup = lookup(value, "backup.schedule.retain", 1)
          last_execution_time      = lookup(value, "backup.schedule.last", timestamp())
          retention_period_days    = lookup(value, "backup.schedule.retention_in_days", 30)
          start_time               = lookup(value, "backup.schedule.start", timestamp())
        }
        storage_account_url = lookup(value, "backup.storage_account_key", null)
      }
      client_affinity_enabled            = lookup(value, "client_affinity_enabled", true)
      client_certificate_enabled         = lookup(value, "client_certificate_enabled", false)
      client_certificate_exclusion_paths = lookup(value, "client_certificate_exclusion_paths", "")
      client_certificate_mode            = lookup(value, "client_certificate_mode", "Required")
      connection_string = {
        name  = lookup(value, "connection_string.name", null)
        type  = lookup(value, "connection_string.type", null)
        value = lookup(value, "connection_string.value", null)
      }
      enabled    = lookup(value, "enabled", true)
      https_only = lookup(value, "https_only", true)
      identity = {
        type         = lookup(value, "identity.type", "SystemAssigned")
        identity_ids = []
      }
      key_vault_reference_identity_id = lookup(value, "key_vault_reference_identity_id", null)
      logs = {
        application_logs = {
          azure_blob_storage = lookup(value, "logs.application_logs.storage_account_key", null)
          file_system_level  = lookup(value, "logs.application_logs.file_sytem_level", "Error")
        }
        detailed_error_messages = lookup(value, "logs.detailed_error_messages", false)
        failed_request_tracing  = lookup(value, "logs.failed_request_tracing", false)
        http_logs = {
          azure_blob_storage = lookup(value, "logs.application_logs.storage_account_key", null)
          file_system = {
            retention_in_days = lookup(value, "logs.http_logs.file_system.retention_in_days", 0)
            retention_in_mb   = lookup(value, "logs.http_logs.file_system.retention_in_mb", 100)
          }
        }
      }
      sticky_settings = {
        app_setting_names       = lookup(value, "sticky_settings.app_setting_names", [])
        connection_string_names = lookup(value, "sticky_settings.connection_string_names", [])
      }
      storage_account = {
        access_key   = "Grab dynamically using storage account outputs"
        account_name = lookup(value, "storage_account.storage_account_key", null)
        name         = lookup(value, "storage_account.name", null)
        share_name   = lookup(value, "storage_account.share_name", null)
        type         = lookup(value, "storage_account.type", "AzureBlob")
        mount_path   = lookup(value, "storage_account.mount_path", null)
      }
      tags = merge(
        var.tags,
        lookup(value, "tags", {
          environment = var.environment
          namespace   = var.namespace
        })
      )
      virtual_network_subnet_id = lookup(value, "virtual_network_subnet_key", null)
      zip_deploy_file           = lookup(value, "zip_deploy_file", null)
    }
  }

}
