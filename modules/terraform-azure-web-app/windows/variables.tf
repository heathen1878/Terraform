variable "windows_web_apps" {
  description = "A map of Windows Web Apps"
  default     = {}
  type = map(object(
    {
      name                = string
      resource_group_name = string
      location            = string
      service_plan_id     = string
      site_config = object(
        {
          always_on             = bool
          api_definition_url    = string
          api_management_api_id = string
          app_command_line      = string
          application_stack = object(
            {
              current_stack       = string
              dotnet_core_version = string
              dotnet_version      = string
              java_version        = string
              node_version        = string
              php_version         = string
              python              = bool
              tomcat_version      = string
            }
          )
          auto_heal_enabled                             = bool
          container_registry_managed_identity_client_id = string
          container_registry_use_managed_identity       = bool
          cors = object(
            {
              allowed_origins     = list(string)
              support_credentials = bool
            }
          )
          default_documents                 = list(string)
          ftps_state                        = string
          health_check_eviction_time_in_min = number
          health_check_path                 = string
          http2_enabled                     = bool
          #ip_restriction                    = list(string)
          load_balancing_mode      = string
          local_mysql_enabled      = bool
          managed_pipeline_mode    = string
          minimum_tls_version      = string
          remote_debugging_enabled = bool
          remote_debugging_version = string
          #scm_ip_restriction                = list(string)
          scm_minimum_tls_version     = string
          scm_type                    = string
          scm_use_main_ip_restriction = bool
          use_32_bit_worker           = bool
          virtual_application = object(
            {
              physical_path     = string
              preload           = bool
              virtual_directory = map(any)
              virtual_path      = string
            }
          )
          vnet_route_all_enabled = bool
          websockets_enabled     = bool
          worker_count           = number
        }
      )
      app_settings = map(any)
      auth_settings = object(
        {
          enabled = bool
        }
      )
      auth_settings_v2 = object(
        {}
      )
      backup = object(
        {
          enabled = bool
          name    = string
          schedule = object(
            {
              frequency_interval       = number
              frequency_unit           = string
              keep_at_least_one_backup = bool
              retention_period_days    = number
              start_time               = string
            }
          )
          storage_account_url = string
        }
      )
      client_affinity_enabled            = bool
      client_certificate_enabled         = bool
      client_certificate_mode            = string
      client_certificate_exclusion_paths = string
      connection_string = object(
        {
          name  = string
          type  = string
          value = string
        }
      )
      enabled    = bool
      https_only = bool
      identity = object(
        {
          identity_ids = list(any)
          type         = string
        }
      )
      ip_restriction                  = list(string)
      key_vault_reference_identity_id = any
      logs = map(object(
        {
          application_logs = object(
            {
              azure_blob_storage = object(
                {
                  level             = string
                  retention_in_days = number
                  sas_url           = string
                }
              )
              file_system_level = string
            }
          )
          detailed_error_messages = bool
          failed_request_tracing  = bool
          http_logs = object(
            {
              azure_blob_storage = object(
                {
                  retention_in_days = number
                  sas_url           = string
                }
              )
              file_system = map(any)
            }
          )
        }
      ))
      sticky_settings           = map(any)
      storage_account           = map(any)
      tags                      = map(any)
      virtual_network_subnet_id = string
      zip_deploy_file           = string
    }
  ))
}