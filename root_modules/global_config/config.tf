locals {
  # AAD
  aad_applications = {
    azdo_service_connection_devtest = {
      display_name     = "Dev Ops DevTest Service Connection"
      description      = "Connects DevOps to the DevTest Management group"
      management_group = "devtest"
      azdo_projects = [
        "pipelines"
      ]
    }
    azdo_service_connection_prod = {
      display_name     = "Dev Ops Production Service Connection"
      description      = "Connects DevOps to the Production Management group"
      management_group = "production"
    }
  }

  aad_applications_config_output = {
    for aad_app_key, aad_app_value in local.aad_applications : aad_app_key => {
      access_token_issuance_enabled    = lookup(aad_app_value, "access_token_issuance_enabled", true)
      app_id                           = random_uuid.aad_application[aad_app_key].result
      azdo_projects                    = lookup(aad_app_value, "azdo_projects", [])
      display_name                     = aad_app_value.display_name
      description                      = lookup(aad_app_value, "description", "Global AAD application registration")
      expire_secret_after              = lookup(aad_app_value, "expire_secret_after", 90)
      homepage_url                     = lookup(aad_app_value, "homepage_url", null)
      id_token_issuance_enabled        = lookup(aad_app_value, "id_token_issuance_enabled", true)
      kv                               = lookup(aad_app_value, "kv", [])
      management_group                 = lookup(aad_app_value, "management_group", "")
      secret_display_name              = replace(aad_app_value.display_name, " ", "-")
      redirect_uris                    = lookup(aad_app_value, "redirect_uris", [])
      rotate_secret_days_before_expiry = lookup(aad_app_value, "rotate_secret_days_before_expiry", 14)
    }
  }

  aad_applications_group_membership = flatten([
    for aad_app_key, aad_app_value in local.aad_applications : [
      for aad_groups_key, aad_groups_value in aad_app_value.aad_groups : {
        group      = aad_groups_value
        membership = aad_app_key
      }
    ]
    if lookup(aad_app_value, "aad_groups", []) != []
  ])

  aad_applications_group_membership_map = {
    for aad_key, aad_value in local.aad_applications_group_membership :
    format("%s_%s", aad_value.membership, aad_value.group) => aad_value
  }

  # MGMT groups
  management_groups = merge(try(var.management_groups, {}), {
    #dev_test = {
    #    display_name = "Development and Test subscriptions"
    #    subscriptions = []
    #}
    }
  )

}