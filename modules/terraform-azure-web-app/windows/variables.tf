variable "windows_web_apps" {
  description = "A map of Windows Web Apps"
  default     = {}
  type = map(object(
    {
      name                               = string
      resource_group_name                = string
      location                           = string
      service_plan_id                    = string
      site_config                        = map(any)
      app_settings                       = map(any)
      auth_settings                      = map(any)
      auth_settings_v2                   = map(any)
      backup                             = map(any)
      client_affinity_enabled            = bool
      client_certificate_enabled         = bool
      client_certificate_mode            = string
      client_certificate_exclusion_paths = string
      connection_string                  = map(any)
      enabled                            = bool
      https_only                         = bool
      identity                           = map(any)
      key_vault_reference_identity_id    = string
      logs                               = map(any)
      sticky_settings                    = map(any)
      storage_account                    = map(any)
      tags                               = map(any)
      #virtual_network_subnet_id = string
      zip_deploy_file = string
    }
  ))
}