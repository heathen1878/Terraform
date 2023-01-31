locals {
  aad_applications = {}

  aad_users = {}

  aad_groups = {
    certificates-officer = {
      description = "Can manage certificates within a Key Vault"
    }
    secrets-officer = {
      description = "Can manage secrets within a Key Vault"
    }
    key-vault-admin = {
      description = "Administrators of Key Vaults"
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

  aad_group_output = {
    for aad_group_key, aad_group_value in local.aad_groups : aad_group_key => {
      name = format("%s-%s-%s-%s", var.namespace, var.environment, lower(replace(var.location, " ", ""), aad_group_key))
      description = lookup(aad_group_value, "description", "")
    }
  }

  aad_applications_group_membership = {
    for group_membership in flatten([
      for aad_app_key, aad_app_value in local.aad_applications : [
        for aad_groups_key, aad_groups_value in aad_app_value.aad_groups : {
          group      = aad_groups_value
          membership = aad_app_key
        }
      ] if lookup(aad_app_value, "aad_groups", []) != []
    ]) : format("%s_%s", group_membership.membership, group_membership.group) => group_membership
  }

  aad_users_group_membership = {
    for group_membership in flatten([
      for aad_user_key, aad_user_value in local.aad_users : [
        for aad_groups_key, aad_groups_value in aad_user_value.aad_groups : {
          group      = aad_groups_value
          membership = aad_user_key
        }
      ] if lookup(aad_user_value, "aad_groups", []) != []
    ]) : format("%s_%s", group_membership.membership, group_membership.group) => group_membership
  }

}