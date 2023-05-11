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

    # TODO review how to best implement this...
    # It should be dynamic enough to restrict access to e.g. 
    # cloudflare
    # or Azure Application Gateway
    #dynamic "ip_restriction" {
    #  for_each = ""
    #
    #      content {
    #        ip_address = 
    #      }
    #    }
    load_balancing_mode      = each.value.site_config.load_balancing_mode
    local_mysql_enabled      = each.value.site_config.local_mysql_enabled
    managed_pipeline_mode    = each.value.site_config.managed_pipeline_mode
    minimum_tls_version      = each.value.site_config.minimum_tls_version
    remote_debugging_enabled = each.value.site_config.remote_debugging_enabled
    remote_debugging_version = each.value.site_config.remote_debugging_version

    #dynamic "scm_ip_restriction" {
    #  for_each = data.terraform_remote_state.mgt-vpn.outputs.vpn_public_ips

    #  content {
    #    ip_address = "${scm_ip_restriction.value}/32"
    #    action     = "Allow"
    #  }
    #}

    #dynamic "scm_ip_restriction" {
    #  for_each = {
    #    for subnet_key, subnet_value in data.terraform_remote_state.mgt-net.outputs.vnet_subnets : subnet_key => subnet_value
    #    if contains(["om-net-snet-build", "om-net-snet-vpn"], subnet_key)
    #  }

    #  content {
    #    virtual_network_subnet_id = scm_ip_restriction.value.subnet_id
    #    action                    = "Allow"
    #  }
    #}

    use_32_bit_worker  = each.value.site_config.use_32_bit_worker
    websockets_enabled = each.value.site_config.websockets_enabled

  }

  # optional
  app_settings = merge(
    each.value.app_settings,
    {

    }
  )


}