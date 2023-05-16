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
    for key, value in local.aad_applications : key => {
      access_token_issuance_enabled    = lookup(value, "access_token_issuance_enabled", true)
      app_id                           = random_uuid.aad_application[key].result
      description                      = lookup(value, "description", "Environment scoped AAD application registration")
      expire_secret_after              = lookup(value, "expire_secret_after", 90)
      homepage_url                     = lookup(value, "homepage_url", null)
      id_token_issuance_enabled        = lookup(value, "id_token_issuance_enabled", true)
      kv                               = lookup(value, "kv", [])
      secret_display_name              = replace(value.display_name, " ", "-")
      redirect_uris                    = lookup(value, "redirect_uris", [])
      rotate_secret_days_before_expiry = lookup(value, "rotate_secret_days_before_expiry", 14)
    }
  }

  aad_users_output = {
    for key, value in local.aad_users : key => {
      forename                      = value.forename
      surname                       = value.surname
      domain_suffix                 = value.domain_suffix
      job_title                     = value.job_title
      enabled                       = value.enabled
      formatted_user_principal_name = format("%s-%s", key, replace(value.domain_suffix, "/\\./", "-"))
      store_in_key_vault            = value.store_in_key_vault
      generate_ssh_keys             = try(value.generate_ssh_keys, false)
      password                      = random_password.aad_user[key].result
      password_expiration           = time_offset.password_expiry[key].rfc3339
    }
  }

  aad_group_output = {
    for key, value in local.aad_groups : key => {
      name        = format("%s-%s-%s-%s", var.namespace, var.environment, lower(replace(var.location, " ", "")), key)
      description = lookup(value, "description", "")
    }
  }

  aad_applications_group_membership = {
    for group_membership in flatten([
      for key, value in local.aad_applications : [
        for groups_key, groups_value in value.aad_groups : {
          group      = groups_value
          membership = key
        }
      ] if lookup(value, "aad_groups", []) != []
    ]) : format("%s_%s", group_membership.membership, group_membership.group) => group_membership
  }

  aad_users_group_membership = {
    for group_membership in flatten([
      for key, value in local.aad_users : [
        for groups_key, groups_value in value.aad_groups : {
          group      = groups_value
          membership = key
        }
      ] if lookup(value, "aad_groups", []) != []
    ]) : format("%s_%s", group_membership.membership, group_membership.group) => group_membership
  }

}