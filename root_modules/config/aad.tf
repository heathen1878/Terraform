locals {
  aad_applications = {
    docker_build = {
      display_name        = "Docker Build"
      description         = "Builds and pushes Docker Images to ACR"
      expire_secret_after = 90
      kv = [
        "management"
      ]
      homepage_url                  = "https://visualstudio/SPN"
      access_token_issuance_enabled = false
      redirect_uris = [
        "https://VisualStudio/SPN"
      ]
      rotate_secret_days_before_expiry = 14
    }
    mgt-dev-azdo-backup = {
      aad_groups = [
        "azdo-project-readers"
      ]
      display_name        = "Azure-DevOps-backup"
      description         = "Dedicated AAD application for cloning repos, zipping them and storing them in a storage account."
      expire_secret_after = 90
      kv = [
        # a list of key vaults where the secrets should be stored - matched up with local.key_vaults
        "management"
      ],
      rotate_secret_days_before_expiry = 14
    }
  }

  aad_users = {
    #mgt-dev-platformautomation = {
    #  forename      = "Platform"
    #  surname       = "Automation"
    #  domain_suffix = var.domain_suffix
    #  enabled       = true
    #  aad_groups    = [
    #    "mgt-dev-azdo-project-readers"
    #  ]
    #  job_title     = "Automation Account"
    #  kv = [
    #    # a list of key vaults where the secrets should be stored - matched up with local.key_vaults
    #    "management"
    #  ]
    #  expire_password_after              = 5
    #  rotate_password_days_before_expiry = 3
    #  generate_ssh_keys                  = true
    #} 
  }

  aad_azdo_groups = {
    azdo = {
      azdo-project-readers = {
        name        = format("%s-%s-azdo-project-readers", var.namespace, var.environment)
        description = "Grants read access to Projects within Azure DevOps"
      }
    }
  }

  aad_kv_groups = {
    kv = {
      certificates-officer = {
        name        = format("%s-%s-%s-certificates-officer", var.namespace, var.environment, lower(replace(var.location, " ", "")))
        description = "Can manage certificates within a Key Vault"
      }
      secrets-officer = {
        name        = format("%s-%s-%s-secrets-officer", var.namespace, var.environment, lower(replace(var.location, " ", "")))
        description = "Can manage secrets within a Key Vault"
      }
      key-vault-admin = {
        name        = format("%s-%s-%s-key-vault-admins", var.namespace, var.environment, lower(replace(var.location, " ", "")))
        description = "Administrators of Key Vaults"
      }
    }
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------

  aad_applications_output = {
    for aad_app_key, aad_app_value in local.aad_applications : aad_app_key => {
      access_token_issuance_enabled    = lookup(aad_app_value, "access_token_issuance_enabled", true)
      app_id                           = random_uuid.aad_application[aad_app_key].result
      description                      = lookup(aad_app_value, "description", "Environment scoped AAD application registration")
      expire_secret_after              = lookup(aad_app_value, "expire_secret_after", 90)
      homepage_url                     = lookup(aad_app_value, "homepage_url", null)
      id_token_issuance_enabled        = lookup(aad_app_value, "id_token_issuance_enabled", true)
      kv                               = lookup(aad_app_value, "kv", [])
      secret_display_name              = replace(aad_app_value.display_name, " ", "-")
      redirect_uris                    = lookup(aad_app_value, "redirect_uris", [])
      rotate_secret_days_before_expiry = lookup(aad_app_value, "rotate_secret_days_before_expiry", 14)
    }
  }

  aad_users_output = {
    for aad_user_key, aad_user_value in local.aad_users : aad_user_key => {
      forename                      = aad_user_value.forename
      surname                       = aad_user_value.surname
      domain_suffix                 = aad_user_value.domain_suffix
      job_title                     = aad_user_value.job_title
      enabled                       = aad_user_value.enabled
      formatted_user_principal_name = format("%s-%s", aad_user_key, replace(aad_user_value.domain_suffix, "/\\./", "-"))
      kv                            = aad_user_value.kv
      generate_ssh_keys             = try(aad_user_value.generate_ssh_keys, false)
      password                      = random_password.aad_user[aad_user_key].result
      password_expiration           = time_offset.password_expiry[aad_user_key].rfc3339
    }
  }

  aad_group_output = merge(local.aad_azdo_groups, local.aad_kv_groups)

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

  aad_users_group_membership = flatten([
    for aad_user_key, aad_user_value in local.aad_users : [
      for aad_groups_key, aad_groups_value in aad_user_value.aad_groups : {
        group      = aad_groups_value
        membership = aad_user_key
      }
    ]
    if lookup(aad_user_value, "aad_groups", []) != []
  ])

  aad_users_group_membership_map = {
    for aad_key, aad_value in local.aad_users_group_membership :
    format("%s_%s", aad_value.membership, aad_value.group) => aad_value
  }

}