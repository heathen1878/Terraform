
#module "service_plans" {
#  source  = "heathen1878/app-service-plan/azurerm"
#  version = "1.0.0"
#
#  service_plans = local.service_plans
#}
#
#module "windows_web_apps" {
#  source = "../../../terraform-azurerm-windows-web-app"
#  #source  = "heathen1878/windows-web-app/azurerm"
#  #version = "1.0.0"
#
#  windows_web_apps = local.windows_web_apps
#}
#
#module "cloudflare_domain_verification_record" {
#  source = "../../modules/terraform-cloudflare/dns_records"
#
#  dns_record = local.web_app_verification_dns_record_cloudflare
#}
#
#module "pre_verify_cloudflare_cname_record" {
#  source = "../../modules/terraform-cloudflare/dns_records"
#
#  dns_record = local.pre_verify_web_app_cname_dns_record_cloudflare
#}
#
#module "azure_domain_verification_record" {
#  source = "../../modules/terraform-azure-dns/records"
#
#  record = local.web_app_verification_dns_record_azure
#}
#
#module "secure_custom_domain" {
#  source = "../../../terraform-azurerm-secure-custom-domain"
#
#  custom_domain = local.web_app_custom_domain
#}
#
#module "post_verify_cloudflare_cname_record" {
#  source = "../../modules/terraform-cloudflare/dns_records"
#
#  dns_record = local.post_verify_web_app_cname_dns_record_cloudflare
#}
#
#locals {
#
#
#  
#  web_app_verification_dns_record_cloudflare = {
#    for dns_record in flatten([
#      for key, value in local.windows_web_apps : [
#        for dns_key, dns_value in value.dns_records : {
#          zone_id = dns_value.zone_id
#          name    = dns_key == "apex" ? format("asuid.%s", dns_value.zone) : format("asuid.%s.%s", dns_key, dns_value.zone)
#          proxied = false
#          value   = module.windows_web_apps.web_app[key].custom_domain_verification_id
#          type    = "TXT"
#          ttl     = dns_value.ttl
#        } if dns_value.cloudflare_protected == true
#      ]
#    ]) : dns_record.name => dns_record
#  }
#
#  web_app_verification_dns_record_azure = {
#    for dns_record in flatten([
#      for key, value in local.windows_web_apps : [
#        for dns_key, dns_value in value.dns_records : {
#          zone_id = dns_value.zone_id
#          name    = dns_key == "apex" ? format("asuid.%s", dns_value.zone) : format("asuid.%s.%s", dns_key, dns_value.zone)
#          value   = module.windows_web_apps.web_app[key].custom_domain_verification_id
#          type    = "TXT"
#          ttl     = dns_value.ttl
#        } if dns_value.azure_managed == true
#      ]
#    ]) : dns_record.name => dns_record
#  }
#
#  pre_verify_web_app_cname_dns_record_cloudflare = {
#    for dns_record in flatten([
#      for key, value in local.windows_web_apps : [
#        for dns_key, dns_value in value.dns_records : {
#          zone_id = dns_value.zone_id
#          name    = dns_key == "apex" ? format("%s", dns_value.zone) : format("%s.%s", dns_key, dns_value.zone)
#          proxied = false
#          value   = module.windows_web_apps.web_app[key].default_hostname
#          type    = dns_value.type
#          ttl     = dns_value.ttl
#        } if dns_value.cloudflare_protected == true
#      ]
#    ]) : dns_record.name => dns_record
#  }
#
#  web_app_cname_dns_record_azure = {
#    for dns_record in flatten([
#      for key, value in local.windows_web_apps : [
#        for dns_key, dns_value in value.dns_records : {
#          zone_id = dns_value.zone_id
#          name    = dns_key == "apex" ? format("%s", dns_value.zone) : format("%s.%s", dns_key, dns_value.zone)
#          value   = module.windows_web_apps.web_app[key].default_hostname
#          type    = dns_value.type
#          ttl     = dns_value.ttl
#        } if dns_value.azure_managed == true
#      ]
#    ]) : dns_record.name => dns_record
#  }
#
#  web_app_custom_domain = {
#    for dns_record in flatten([
#      for key, value in local.windows_web_apps : [
#        for dns_key, dns_value in value.dns_records : {
#          hostname            = dns_key == "apex" ? format("%s", dns_value.zone) : format("%s.%s", dns_key, dns_value.zone)
#          app_service_name    = module.windows_web_apps.web_app[key].name
#          location = value.location
#          resource_group_name = module.windows_web_apps.web_app[key].resource_group_name
#          key_vault_id = 
#        } if dns_value.cloudflare_protected == true
#      ]
#    ]) : dns_record.hostname => dns_record
#  }
#
#  post_verify_web_app_cname_dns_record_cloudflare = {
#    for dns_record in flatten([
#      for key, value in local.windows_web_apps : [
#        for dns_key, dns_value in value.dns_records : {
#          zone_id = dns_value.zone_id
#          name    = dns_key == "apex" ? format("%s", dns_value.zone) : format("%s.%s", dns_key, dns_value.zone)
#          proxied = true
#          value   = module.windows_web_apps.web_app[key].default_hostname
#          type    = dns_value.type
#          ttl     = dns_value.ttl
#        } if dns_value.cloudflare_protected == true
#      ]
#    ]) : dns_record.name => dns_record
#  }
#
#
#
#  #custom_domain_certificate = {
#  #  for key, value in data.terraform_remote_state.config.outputs.dns.web_app_association : key => {
#  #    name                = key
#  #    resource_group_name = module.windows_web_apps.web_app[value.web_app].resource_group_name
#  #    location            = module.windows_web_apps.web_app[value.web_app].location
#  #    app_service_plan_id = module.windows_web_apps.web_app[value.web_app].id
#  #    key_vault_secret_id = module.key_vault_secrets.secret[value.zone].id
#  #  }
#  #}
#
#  #web_app_custom_domain = {
#  #  for key, value in data.terraform_remote_state.config.outputs.cloudflare.dns_records : key => {
#  #    hostname            = key == "apex" ? replace(value.zone, "_", ".") : format("%s.%s", key, replace(value.zone, "_", "."))
#  #    app_service_name    = module.windows_web_apps.web_app[value.associated_web_app].name
#    resource_group_name = module.windows_web_apps.web_app[value.associated_web_app].resource_group_name
#    ssl_state           = null
#    thumbprint          = null
#  }
#}

#cloudflare_cname_record = {
#  for key, value in data.terraform_remote_state.config.outputs.cloudflare.dns_records : key => {
#    zone_id = module.cloudflare_zone.zone[value.zone].id
#    name    = key == "apex" ? replace(value.zone, "_", ".") : key
#    proxied = value.proxied
#    value   = module.windows_web_apps.web_app[value.associated_web_app].default_hostname
#    type    = value.type
#    ttl     = value.ttl
#  }
#}

#}