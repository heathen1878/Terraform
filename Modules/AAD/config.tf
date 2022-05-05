locals {
  aad_applications = {
    mgt-azdo-backup = {
      display_name = "Azure-DevOps-backup"
      aad_groups = [
        "application-azdo-project-readers"
      ]
      description = "Dedicated AAD application for cloning repos, zipping them and storing them in a storage account."
      service_principal_secret_kv = [
        # a list of key vaults where the service principal secret should be stored. 
        "secrets_accesspolicy" # mgt-secrets-kv
      ],
      expire_secret_after              = 5
      rotate_secret_days_before_expiry = 3
    }
  }

  aad_users = {
    platformautomation = {
      forename      = "Platform"
      surname       = "Automation"
      domain_suffix = "infratechy.co.uk"
      enabled       = true
      aad_groups    = [
        "application-azdo-project-readers"
      ]
      job_title     = "Automation Account"
      user_secrets_kv = [
        # a list of key vaults where the service principal secret should be stored. 
        "secrets_accesspolicy" # mgt-secrets-kv
      ]
      expire_password_after              = 5
      rotate_password_days_before_expiry = 3
      generate_ssh_keys                  = true
    } 
  }

  aad_groups = {
    application-azdo-project-readers = {
      description = "Grants read access to Projects within Azure DevOps"
    }
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------
  # AAD SP group membership
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
    aad_applications_group_membership = {
      for aad_key, aad_value in local.aad_applications_group_membership :
      format("%s_%s", aad_value.membership, aad_value.group) => aad_value
    }
  }

  aad_applications_output = {
    for aad_app_key, aad_app_value in azuread_application.aad_application : aad_app_key => {
      application_id                   = aad_app_value.application_id
      display_name                     = aad_app_value.display_name
      object_id                        = aad_app_value.object_id
      kv                               = local.aad_applications[aad_app_key].service_principal_secret_kv
      secret_display_name              = local.aad_applications[aad_app_key].display_name
      expire_secret_after              = local.aad_applications[aad_app_key].expire_secret_after
      rotate_secret_days_before_expiry = local.aad_applications[aad_app_key].rotate_secret_days_before_expiry
    }
  }

  aad_users_output = {
    for aad_user_key, aad_user_value in azuread_user.mgt_aad_user : aad_user_key => {
      user_principal_name = aad_user_value.user_principal_name
      object_id           = aad_user_value.object_id
      kv                  = local.aad_users[aad_user_key].user_secrets_kv
      generate_ssh_keys   = try(local.aad_users[aad_user_key].generate_ssh_keys, false)
      password            = random_password.aad_user[aad_user_key].result
      password_expiration = time_offset.password_expiry[aad_user_key].rfc3339
    }
  }

}