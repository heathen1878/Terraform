variable "bootstrap" {
  description = "The Key Vault that contains secrets for bootstrapping Terraform Configuration"
  type = map(object(
    {
      name           = string
      resource_group = string
    }
  ))
}

variable "dns_records" {
  description = "A map of DNS records"
  default     = {}
  type = map(object(
    {
      azure_managed        = optional(bool, false)
      cloudflare_protected = optional(bool, false)
      associated_web_app   = optional(string)
      type                 = optional(string, "A")
      ttl                  = optional(number, 3600)
      proxy_status         = optional(bool, true)
      zone_key             = optional(string)
      content              = optional(string)
    }
  ))
}

variable "container_groups" {
  description = "A map of container instances to deploy"
  default     = {}
  type = map(
    map(
      object(
        {
          acr                   = string
          acr_image             = string
          name                  = string
          environment_variables = string
        }
      )
    )
  )
}

variable "environment" {
  description = "Environment: Dev, Test, Prod..."
  type        = string
}

variable "windows_function_apps" {
  description = "Windows Web Apps for this environment"
  default     = {}
  type = map(object(
    {
      name           = string
      resource_group = string
      sku            = optional(string, "Y1")
      site_config = optional(object({
        always_on             = optional(bool, false)
        api_definition_url    = optional(string, null)
        api_management_api_id = optional(string, null)
        app_command_line      = optional(string, null)
        app_scale_limit       = optional(number, 1)
        application_stack = optional(object({
          dotnet_version              = optional(string, "v4.0")
          use_dotnet_isolated_runtime = optional(bool, false)
          java_version                = optional(string, "17.0.2")
          node_version                = optional(string, "~18")
          powershell_core_version     = optional(string, "7")
        }), {})
        app_service_logs = optional(object({
          disk_quota_mb         = optional(number, 35)
          retention_period_days = optional(number, 0)
        }), {})
        container_registry_managed_identity_client_id = optional(string, null)
        container_registry_use_managed_identity       = optional(bool, false)
        cors = optional(object({
          allowed_origins     = optional(list(string), [])
          support_credentials = optional(bool, false)
        }), {})
        default_documents = optional(list(string), [
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
        ftps_state                        = optional(string, "Disabled")
        health_check_path                 = optional(string, "")
        health_check_eviction_time_in_min = optional(number, 10)
        http2_enabled                     = optional(bool, false)
        load_balancing_mode               = optional(string, "LeastRequests")
        managed_pipeline_mode             = optional(string, "Integrated")
        minimum_tls_version               = optional(string, "1.2")
        remote_debugging_enabled          = optional(bool, false)
        remote_debugging_version          = optional(string, "VS2019")
        scm_minimum_tls_version           = optional(string, "1.2")
        scm_use_main_ip_restriction       = optional(bool, false)
        use_32_bit_worker                 = optional(bool, true)
        websockets_enabled                = optional(bool, false)
        worker_count                      = optional(number, 1)
      }), {})
      auth_settings = optional(object({
        enabled = optional(bool, false)
      }), {})
      auth_settings_v2 = optional(object({
      }), {})
      app_settings = optional(object({
      }), {})
      backup = optional(object({
        enabled = optional(bool, false)
        name    = optional(string, "custom backups")
        schedule = optional(object({
          frequency_interval       = optional(number, 1)
          frequency_unit           = optional(string, "Day")
          keep_at_least_one_backup = optional(bool, true)
          retention_period_days    = optional(number, 30)
          start_time               = optional(string, "")
        }), {})
        storage_account_url = optional(string, "")
      }), {})
      builtin_logging_enabled            = optional(bool, true)
      client_certificate_enabled         = optional(string, false)
      client_certificate_exclusion_paths = optional(string, "")
      client_certificate_mode            = optional(string, "Required")
      cloudflare_protected               = optional(bool, false)
      connection_string = optional(object({
        name  = optional(string, null)
        type  = optional(string, null)
        value = optional(string, null)
      }), {})
      content_share_force_disabled = optional(bool, false)
      deploy_slot                  = optional(bool, true)
      enabled                      = optional(bool, true)
      enable_private_endpoint      = optional(bool, false)
      functions_extension_version  = optional(string, "~4")
      https_only                   = optional(bool, true)
      identity = optional(object({
        type         = optional(string, "SystemAssigned")
        identity_ids = optional(list(string), [])
      }), {})
      key_vault_reference_identity_id = optional(string, null)
      sticky_settings = optional(object({
        app_setting_names       = optional(string, null)
        connection_string_names = optional(string, null)
      }), {})
      storage_account = optional(object({
        access_key   = optional(string)
        account_name = optional(string, null)
        name         = optional(string, null)
        share_name   = optional(string, null)
        type         = optional(string, "AzureBlob")
        mount_path   = optional(string, null)
      }), {})
      storage_uses_managed_identity                 = optional(bool, true)
      tags                                          = optional(map(any), {})
      virtual_network_subnet_private_endpoint_key   = optional(string, "function_apps_frontend")
      virtual_network_subnet_integration_subnet_key = optional(string, null)
      zip_deploy_file                               = optional(string, null)
  }))
}

variable "location" {
  description = "Location name"
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "management_groups" {
  description = "A map of management groups to manage"
  default     = {}
  type = map(object(
    {
      display_name  = string
      subscriptions = list(string)
    }
  ))
}

variable "management_subscription" {
  description = "The management subscription id"
  type        = string
}

variable "namespace" {
  description = "The namespace for the deployment e.g. mgt, dom, "
  type        = string
}

variable "nsg_rules" {
  description = "A map of rules"
  default     = {}
  type = map(object(
    {
      resource_group = string
      rules = map(object(
        {
          name                         = string
          priority                     = number
          protocol                     = string
          direction                    = string
          access                       = string
          description                  = string
          source_port_range            = string
          source_port_ranges           = list(string)
          destination_port_range       = string
          destination_port_ranges      = list(string)
          source_address_prefix        = string
          source_address_prefixes      = list(string)
          destination_address_prefix   = string
          destination_address_prefixes = list(string)
        }
      ))
      tags = optional(map(any))
    }
  ))
}

variable "state_storage_account" {
  description = "storage account where Terraform state is stored; primarily used by data resources"
  default     = ""
  type        = string
}

variable "tags" {
  description = "Tags required for the resource groups and resources"
  default = {
    Application = "Placeholder"
    Criticality = "Placeholder"
    Datadog     = ""
    IaC         = "Terraform"
    Owner       = "Placeholder"
    Project     = "Placeholder"
  }
  type = map(any)
}

variable "tenant_id" {
  description = "AAD tenant id"
  type        = string
}

variable "windows_web_apps" {
  description = "Windows Web Apps for this environment"
  default     = {}
  type = map(object(
    {
      name           = string
      resource_group = string
      site_config = optional(object({
        always_on             = optional(bool, false)
        api_definition_url    = optional(string, null)
        api_management_api_id = optional(string, null)
        app_command_line      = optional(string, null)
        application_stack = optional(object({
          current_stack       = optional(string, "dotnet")
          dotnet_version      = optional(string, "v4.0")
          dotnet_core_version = optional(string, "v4.0")
          node_version        = optional(string, "~18")
          python              = optional(bool, false)
          php_version         = optional(string, "Off")
          java_version        = optional(string, "17.0.2")
          tomcat_version      = optional(string, "10.0.20")
        }), {})
        auto_heal_enabled                             = optional(bool, false)
        container_registry_managed_identity_client_id = optional(string, null)
        container_registry_use_managed_identity       = optional(bool, false)
        cors = optional(object({
          allowed_origins     = optional(list(string), [])
          support_credentials = optional(bool, false)
        }), {})
        default_documents = optional(list(string), [
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
        ftps_state                        = optional(string, "FtpsOnly")
        health_check_path                 = optional(string, "")
        health_check_eviction_time_in_min = optional(number, 10)
        http2_enabled                     = optional(bool, false)
        load_balancing_mode               = optional(string, "LeastRequests")
        local_mysql_enabled               = optional(bool, false)
        managed_pipeline_mode             = optional(string, "Integrated")
        minimum_tls_version               = optional(string, "1.2")
        remote_debugging_enabled          = optional(bool, false)
        remote_debugging_version          = optional(string, "VS2019")
        scm_minimum_tls_version           = optional(string, "1.2")
        scm_type                          = optional(string, "None")
        scm_use_main_ip_restriction       = optional(bool, false)
        use_32_bit_worker                 = optional(bool, true)
        virtual_application = optional(object({
          physical_path = optional(string, "site\\wwwroot")
          preload       = optional(bool, false)
          virtual_directory = optional(object({
            physical_path = optional(string, null)
            virtual_path  = optional(string, null)
          }), {})
        }), {})
        websockets_enabled = optional(bool, false)
        worker_count       = optional(number, 1)
      }), {})
      application_gateway_protected = optional(bool, false)
      auth_settings = optional(object({
        enabled = optional(bool, false)
      }), {})
      auth_settings_v2 = optional(object({
      }), {})
      app_settings = optional(map(any), {})
      backup = optional(object({
        enabled = optional(bool, false)
        name    = optional(string, "custom backups")
        schedule = optional(object({
          frequency_interval       = optional(number, 1)
          frequency_unit           = optional(string, "Day")
          keep_at_least_one_backup = optional(bool, true)
          retention_period_days    = optional(number, 30)
          start_time               = optional(string, "")
        }), {})
        storage_account_url = optional(string, "")
      }), {})
      client_affinity_enabled            = optional(string, true)
      client_certificate_enabled         = optional(string, false)
      client_certificate_exclusion_paths = optional(string, "")
      client_certificate_mode            = optional(string, "Required")
      cloudflare_protected               = optional(bool, false)
      connection_string = optional(object({
        name  = optional(string, null)
        type  = optional(string, null)
        value = optional(string, null)
      }), {})
      deploy_slot             = optional(bool, true)
      enabled                 = optional(bool, true)
      enable_private_endpoint = optional(bool, false)
      https_only              = optional(bool, true)
      identity = optional(object({
        type         = optional(string, "SystemAssigned")
        identity_ids = optional(list(string), [])
      }), {})
      key_vault_reference_identity_id = optional(string, null)
      logs = optional(object({
        application_logs = optional(object({
          azure_blob_storage = optional(object({
            level             = optional(string, "Error")
            retention_in_days = optional(number, 0)
            sas_url           = optional(string, "https://st.blob.core.windows.net/?sas_token")
          }), {})
          file_system_level = optional(string, "Error")
        }), {})
        detailed_error_messages = optional(bool, false)
        failed_request_tracing  = optional(bool, false)
        http_logs = optional(object({
          azure_blob_storage = optional(object({
            retention_in_days = optional(number, 0)
            sas_url           = optional(string, "https://st.blob.core.windows.net/?sas_token")
          }), {})
          file_system = optional(object({
            retention_in_days = optional(number, 0)
            retention_in_mb   = optional(number, 100)
          }), {})
        }), {})
      }), {})
      sticky_settings = optional(object({
        app_setting_names       = optional(string, null)
        connection_string_names = optional(string, null)
      }), {})
      storage_account = optional(object({
        access_key   = optional(string)
        account_name = optional(string, null)
        name         = optional(string, null)
        share_name   = optional(string, null)
        type         = optional(string, "AzureBlob")
        mount_path   = optional(string, null)
      }), {})
      tags                                          = optional(map(any), {})
      virtual_network_subnet_private_endpoint_key   = optional(string, "app_services_frontend")
      virtual_network_subnet_integration_subnet_key = optional(string, null)
      zip_deploy_file                               = optional(string, null)
  }))
}

variable "virtual_networks" {
  description = "A virtual network for this environment"
  default     = {}
  type = map(object(
    {
      resource_group = string
      address_space  = list(string)
      dns_servers    = list(string)
      peers          = list(string)
    }
  ))
}
