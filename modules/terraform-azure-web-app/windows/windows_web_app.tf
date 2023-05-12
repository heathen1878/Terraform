resource "azurerm_windows_web_app" "windows_web_app" {

  for_each = var.windows_web_apps

  # required
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  service_plan_id     = each.value.service_plan_id
  site_config {
    always_on             = each.value.site_config.always_on
    api_definition_url    = each.value.site_config.api_definition_url
    api_management_api_id = each.value.site_config.api_management_api_id
    app_command_line      = each.value.site_config.app_command_line

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack.current_stack == "dotnet" ? { "application_stack" = "dotnet" } : {}

      content {
        dotnet_version = each.value.site_config.application_stack.dotnet_version
      }
    }

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack.current_stack == "dotnetcore" ? { "application_stack" = "dotnetcore" } : {}

      content {
        dotnet_core_version = each.value.site_config.application_stack.dotnet_core_version
      }
    }

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack.current_stack == "node" ? { "application_stack" = "node" } : {}

      content {
        node_version = each.value.site_config.application_stack.node_version
      }
    }

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack.current_stack == "python" ? { "application_stack" = "python" } : {}

      content {
        python = each.value.site_config.application_stack.python
      }
    }

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack.current_stack == "php" ? { "application_stack" = "php" } : {}

      content {
        php_version = each.value.site_config.application_stack.php_version
      }
    }

    dynamic "application_stack" {
      for_each = each.value.site_config.application_stack.current_stack == "java" ? { "application_stack" = "java" } : {}

      content {
        java_version   = each.value.site_config.application_stack.java_version
        tomcat_version = each.value.site_config.application_stack.tomcat_version
      }
    }

    cors {
      allowed_origins     = each.value.site_config.cors.allowed_origins
      support_credentials = each.value.site_config.cors.support_credentials
    }

    default_documents = each.value.site_config.default_documents
    ftps_state        = each.value.site_config.ftps_state

    health_check_eviction_time_in_min = each.value.site_config.health_check_eviction_time_in_min
    health_check_path                 = each.value.site_config.health_check_path

    http2_enabled = each.value.site_config.http2_enabled

    # Cloudflare or Azure Application Gateway
    dynamic "ip_restriction" {

      for_each = each.value.ip_restriction

      content {
        ip_address = ip_restriction.value
      }
    }

    load_balancing_mode      = each.value.site_config.load_balancing_mode
    local_mysql_enabled      = each.value.site_config.local_mysql_enabled
    managed_pipeline_mode    = each.value.site_config.managed_pipeline_mode
    minimum_tls_version      = each.value.site_config.minimum_tls_version
    remote_debugging_enabled = each.value.site_config.remote_debugging_enabled
    remote_debugging_version = each.value.site_config.remote_debugging_version

    # Cloudflare or Azure Application Gateway
    dynamic "scm_ip_restriction" {
      for_each = each.value.ip_restriction

      content {
        ip_address = scm_ip_restriction.value

      }
    }

    use_32_bit_worker  = each.value.site_config.use_32_bit_worker
    websockets_enabled = each.value.site_config.websockets_enabled
  }

  # optional
  app_settings = merge(
    each.value.app_settings,
    {

    }
  )

  dynamic "auth_settings" {
    for_each = each.value.auth_settings

    content {
      enabled = auth_settings.value.enabled
    }
  }

  # TODO look at the implementation of this feature
  #dynamic "auth_settings_v2" {
  #  for_each = each.value.auth_settings_v2

  #  content {
  #  }
  #}

  dynamic "backup" {
    for_each = each.value.backup.enabled == true ? { "backups" = "enabled" } : {}

    content {
      enabled = backup.value.enabled
      name    = backup.value.name
      schedule {
        frequency_interval       = backup.value.schedule.frequency_interval
        frequency_unit           = backup.value.schedule.frequency_unit
        keep_at_least_one_backup = backup.value.schedule.keep_at_least_one_backup
        retention_period_days    = backup.value.schedule.retention_period_days
        start_time               = backup.value.schedule.start_time
      }
      storage_account_url = backup.value.storage_account_url
    }
  }

  client_affinity_enabled            = each.value.client_affinity_enabled
  client_certificate_enabled         = each.value.client_certificate_enabled
  client_certificate_mode            = each.value.client_certificate_mode
  client_certificate_exclusion_paths = each.value.client_certificate_exclusion_paths

  dynamic "connection_string" {
    for_each = each.value.connection_string.name != null ? { "connection_strings" = "enabled" } : {}

    content {
      name  = connection_string.name
      type  = connection_string.type
      value = connection_string.value
    }
  }

  enabled    = each.value.enabled
  https_only = each.value.https_only

  identity {
    type         = each.value.identity.type
    identity_ids = each.value.identity.identity_ids
  }

  key_vault_reference_identity_id = each.value.key_vault_reference_identity_id

  dynamic "logs" {
    for_each = each.value.logs

    content {
      application_logs {
        dynamic "azure_blob_storage" {
          for_each = logs.value.application_logs.azure_blob_storage.retention_in_days != 0 ? { "logging" = "blob" } : {}

          content {
            level             = logs.value.application_logs.azure_blob_storage.level
            retention_in_days = logs.value.application_logs.azure_blob_storage.retention_in_days
            sas_url           = logs.value.application_logs.azure_blob_storage.sas_url
          }
        }
        file_system_level = logs.value.application_logs.file_system_level
      }
      detailed_error_messages = logs.value.detailed_error_messages
      failed_request_tracing  = logs.value.failed_request_tracing
      http_logs {
        dynamic "azure_blob_storage" {
          for_each = logs.value.http_logs.azure_blob_storage.retention_in_days != 0 ? { "logging" = "blob" } : {}

          content {
            retention_in_days = azure_blob_storage.retention_in_days
            sas_url           = azure_blob_storage.sas_url
          }
        }
        dynamic "file_system" {
          for_each = logs.value.http_logs.file_system.retention_in_days != 0 ? { "logging" = "file system" } : {}

          content {
            retention_in_days = file_system.retention_in_days
            retention_in_mb   = file_system.retention_in_mb
          }
        }
      }

    }

  }

  dynamic "sticky_settings" {
    for_each = each.value.sticky_settings.app_setting_names != null && each.value.sticky_settings.connection_string_names != null ? {} : {}

    content {
      app_setting_names       = each.value.sticky_settings.app_setting_names
      connection_string_names = each.value.sticky_settings.connection_string_names
    }
  }

  dynamic "sticky_settings" {
    for_each = each.value.sticky_settings.app_setting_names != null ? { "sticky app settings" = "enabled" } : {}

    content {
      app_setting_names = each.value.sticky_settings.app_setting_names
    }
  }

  dynamic "sticky_settings" {
    for_each = each.value.sticky_settings.connection_string_names != null ? { "sticky connection strings" = "enabled" } : {}

    content {
      connection_string_names = each.value.sticky_settings.connection_string_names
    }
  }

  dynamic "storage_account" {
    for_each = each.value.storage_account.account_name != null ? { "storage_account" = "enabled" } : {}

    content {
      access_key   = storage_account.access_key
      account_name = storage_account.account_name
      name         = storage_account.name
      share_name   = storage_account.share_name
      type         = storage_account.type
      mount_path   = storage_account.mount_path
    }
  }

  tags                      = each.value.tags
  virtual_network_subnet_id = each.value.virtual_network_subnet_id
  zip_deploy_file           = each.value.zip_deploy_file
}