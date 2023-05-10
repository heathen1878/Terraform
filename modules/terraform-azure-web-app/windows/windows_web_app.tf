resource "azurerm_windows_web_app" "windows_web_app" {

  for_each = var.windows_web_app

  # required
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  service_plan_id     = each.value.service_plan_id
  site_config {
    always_on = each.value.always_on

    dynamic "application_stack" {
      for_each = each.value.application_stack.dotnet_version != null ? { "application_stack" = "dotnet" } : {}

      content {
        dotnet_version              = each.value.application_stack.dotnet_version
        use_dotnet_isolated_runtime = each.value.application_stack.use_dotnet_isolated_runtime
      }
    }


    application_stack {
      current_stack  = each.value.application_stack.current_stack
      dotnet_version = each.value.application_stack.dotnet_version
      node_version   = each.value.application_stack.node_version
      php_version    = each.value.application_stack.php_version
      python_version = each.value.application_stack.python_version
    }

    cors {
      allowed_origins = each.value.cors_allowed_origins
    }

    default_documents = [
      "Default.htm",
      "Default.html",
      "Default.asp",
      "index.htm",
      "index.html",
      "iisstart.htm",
      "default.aspx",
      "index.php",
      "hostingstart.html"
    ]

    ftps_state    = "Disabled"
    http2_enabled = each.value.http2_enabled

    dynamic "ip_restriction" {
      for_each = data.terraform_remote_state.mgt-vpn.outputs.vpn_public_ips

      content {
        ip_address = format("%s/32", ip_restriction.value)
      }
    }

    dynamic "ip_restriction" {
      for_each = toset(each.value.ip_restriction)

      content {
        ip_address = ip_restriction.value
      }
    }

    dynamic "ip_restriction" {
      for_each = try({ "waf_ip_address" = format("%s/32", data.terraform_remote_state.waf.outputs.waf_ip_address) }, {})

      content {
        ip_address = ip_restriction.value
      }
    }

    dynamic "ip_restriction" {
      for_each = try(data.terraform_remote_state.net.outputs.vnet_subnets, {})

      content {
        virtual_network_subnet_id = ip_restriction.value.id
        action                    = "Allow"
      }
    }

    dynamic "ip_restriction" {
      for_each = data.terraform_remote_state.mgt-net.outputs.vnet_subnets

      content {
        virtual_network_subnet_id = ip_restriction.value.subnet_id
        action                    = "Allow"
      }
    }

    local_mysql_enabled      = each.value.local_mysql_enabled
    managed_pipeline_mode    = "Integrated"
    minimum_tls_version      = each.value.minimum_tls_version
    remote_debugging_enabled = false

    dynamic "scm_ip_restriction" {
      for_each = data.terraform_remote_state.mgt-vpn.outputs.vpn_public_ips

      content {
        ip_address = "${scm_ip_restriction.value}/32"
        action     = "Allow"
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = {
        for subnet_key, subnet_value in data.terraform_remote_state.mgt-net.outputs.vnet_subnets : subnet_key => subnet_value
        if contains(["om-net-snet-build", "om-net-snet-vpn"], subnet_key)
      }

      content {
        virtual_network_subnet_id = scm_ip_restriction.value.subnet_id
        action                    = "Allow"
      }
    }

    use_32_bit_worker  = each.value.use_32_bit_worker
    websockets_enabled = false

  }


}