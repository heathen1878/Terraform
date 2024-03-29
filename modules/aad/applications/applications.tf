resource "azuread_application" "aad_application" {
  for_each = data.terraform_remote_state.config.outputs.aad_applications

  display_name     = each.key
  identifier_uris  = []
  sign_in_audience = "AzureADMyOrg"

  api {
    known_client_applications      = []
    mapped_claims_enabled          = false
    requested_access_token_version = 1

    oauth2_permission_scope {
      admin_consent_description  = format("Allow the application to access %s on behalf of the signed-in user.", each.key)
      admin_consent_display_name = format("Access %s", each.key)
      enabled                    = true
      id                         = each.value.app_id
      type                       = "User"
      user_consent_description   = format("Allow the application to access %s on your behalf.", each.key)
      user_consent_display_name  = format("Access %s", each.key)
      value                      = "user_impersonation"
    }
  }

  group_membership_claims = []

  owners = [
    data.azuread_client_config.current.object_id
  ]

  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    resource_access {
      id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6" # User.Read
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }

  web {
    homepage_url  = each.value.homepage_url
    redirect_uris = each.value.redirect_uris

    implicit_grant {
      access_token_issuance_enabled = each.value.access_token_issuance_enabled
      id_token_issuance_enabled     = each.value.id_token_issuance_enabled
    }
  }

  # sleep to allow MS Graph to update changes, it can be slow to be visible to dependent resources
  # This works in PowerShell on Windows and Linux. For bash uncomment the alternative command and comment out the PowerShell command and interpreter.
  provisioner "local-exec" {
    command = "Start-Sleep 180"
    #command = "sleep 180"
    interpreter = ["PowerShell", "-NoProfile", "-Command"]
  }

}

resource "azuread_service_principal" "aad_application_principal" {
  for_each = data.terraform_remote_state.config.outputs.aad_applications

  application_id               = azuread_application.aad_application[each.key].application_id
  app_role_assignment_required = true
  description                  = each.value.description

}

# Generate a service principal secret if time rotation has passed
resource "azuread_application_password" "aad_application" {
  for_each = data.terraform_remote_state.config.outputs.aad_applications

  display_name          = "tf-generated"
  application_object_id = azuread_application.aad_application[each.key].object_id
  end_date_relative     = format("%sh", each.value.expire_secret_after * 24)
  rotate_when_changed = {
    rotation = time_rotating.secret_rotation[each.key].id
  }

}

locals {

  aad_applications_output = {
    for aad_app_key, aad_app_value in azuread_application.aad_application : aad_app_key => {
      object_id                = aad_app_value.object_id
      kv                       = data.terraform_remote_state.config.outputs.aad_applications[aad_app_key].kv
      secret                   = azuread_application_password.aad_application[aad_app_key].value
      secret_display_name      = data.terraform_remote_state.config.outputs.aad_applications[aad_app_key].secret_display_name
      secret_expiration        = time_offset.secret_expiry[aad_app_key].rfc3339
      service_principal_id     = azuread_service_principal.aad_application_principal[aad_app_key].object_id
      service_principal_app_id = azuread_application.aad_application[aad_app_key].application_id
    }
  }

}