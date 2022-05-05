variable "location" {
    description = "Location name"
    default = "North Europe"
    type = string
}

variable "environment" {
    description = "Environment: Dev, Test, Prod..."
    default = "Dev"
    type = string
}

variable "usage" {
    description = "The resource group usage - application or infrastructure"
    default = "Change This"
    type = string
}

variable "tags" {
    description = "Tags required for the resource groups and resources"
    default = {
        IaC = "Terraform"
        environment = "Learning"
        applicationName = "Change This"
        location = "North Europe"
    }
}

variable "keyVaultAdmin" {
    description = "Group or User assigned Key Vault Administrator"
    type = string
}

variable "keyVaultSecretsOfficer" {
    description = "Group or User assigned Key Vault Secrets Officer"
    type = string
}

variable "keyVaultCertificatesOfficer" {
    description = "Group or User assigned Key Vault Certificates Officer"
    type = string
}

locals {

    # AAD applications secret kv locations
    aad_application_secret_kv_locations = flatten([
        for aad_app_key, aad_app_value in data.terraform_remote_state.mgt-aad.outputs.aad_applications : [
        for aad_kv_location_key, aad_kv_location_value in aad_app_value.kv : {
            secret_display_name              = aad_app_value.secret_display_name
            kv                               = aad_kv_location_value
            aad_sp                           = aad_app_key
            expire_secret_after              = aad_app_value.expire_secret_after
            rotate_secret_days_before_expiry = aad_app_value.rotate_secret_days_before_expiry
        }
        ]
        if lookup(aad_app_value, "service_principal_secret_kv", []) != []
    ])

    aad_application_secret_kv_locations_map = {
        aad_application_secret_kv_locations = {
        for aad_key, aad_value in local.aad_application_secret_kv_locations : format("%s_%s", aad_value.aad_sp, aad_value.kv) => aad_value
        }
    }

    aad_users_secret_kv_locations = flatten([
        for aad_user_key, aad_user_value in data.terraform_remote_state.mgt-aad.outputs.aad_users : [
        for aad_kv_location_key, aad_kv_location_value in aad_user_value.kv : {
            key                             = aad_user_key
            kv                              = app_kv_location_value
            user_principal_name             = aad_user_value.user_principal_name
            password                        = aad_user_value.password
        }
        ]
    ])

    aad_users_secret_kv_locations_map = {
        aad_user_secret_kv_locations = {
        for aad_key, aad_value in local.aad_users_secret_kv_locations : format("%s_%s", aad_value.key, aad_value.kv) => aad_value
        }
    }

}