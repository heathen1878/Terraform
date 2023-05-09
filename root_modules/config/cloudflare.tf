locals {

  zones = {

    default = {
      domain = "infratechy.co.uk"
    }

  }

  dns_records = {
    www = {

    }
  }

  env_dns_records = merge(
    local.dns_records,
    {

    }
  )

  env_dns_records_output = {
    for key, value in local.env_dns_records : key => {
      content      = lookup(value, "content", "app_gateway_key")
      type         = lookup(value, "type", "A")
      ttl          = lookup(value, "ttl", 3600)
      proxy_status = lookup(value, "proxy_status", true)
      zone         = lookup(value, "zone", local.zones["default"].domain)
    }
  }

}