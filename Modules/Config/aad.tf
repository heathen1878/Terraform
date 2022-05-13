locals {
  aad_applications = {
    mgt-dev-azdo-backup = {
      display_name = "Azure-DevOps-backup"
      aad_groups = [
        "mgt-dev-azdo-project-readers"
      ]
      description = "Dedicated AAD application for cloning repos, zipping them and storing them in a storage account."
      service_principal_secret_kv = [
        # a list of key vaults where the service principal secret should be stored. 
        "management" # mgt-secrets-kv
      ],
      expire_secret_after              = 5
      rotate_secret_days_before_expiry = 3
    }
  }

  aad_users = {
    mgt-dev-platformautomation = {
      forename      = "Platform"
      surname       = "Automation"
      domain_suffix = var.domain_suffix
      enabled       = true
      aad_groups    = [
        "mgt-dev-azdo-project-readers"
      ]
      job_title     = "Automation Account"
      user_secrets_kv = [
        # a list of key vaults where the service principal secret should be stored. 
        "management"
      ]
      expire_password_after              = 5
      rotate_password_days_before_expiry = 3
      generate_ssh_keys                  = true
    } 
  }

  aad_azdo_groups = {
    azdo = {
      mgt-dev-azdo-project-readers = {
        description = "Grants read access to Projects within Azure DevOps"
      }
    }
  }

  aad_kv_groups = {
    kv = {
      mgt-dev-certificate-officers = {
        description = "Can manage certificates within a Key Vault"
      }
      mgt-dev-secret-officers = {
        description = "Can manage secrets within a Key Vault"
      }
      mgt-dev-key-vault-admins = {
        description = "Administrators of Key Vaults"
      }
    }
  }
  
  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------

  aad_applications_output = {
    for aad_app_key, aad_app_value in local.aad_applications : aad_app_key => {
      app_id                           = random_uuid.aad_application[aad_app_key].result
      description                      = aad_app_value.description
      kv                               = aad_app_value.service_principal_secret_kv
      secret_display_name              = aad_app_value.display_name
      expire_secret_after              = aad_app_value.expire_secret_after
      rotate_secret_days_before_expiry = aad_app_value.rotate_secret_days_before_expiry
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
      kv                            = aad_user_value.user_secrets_kv
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