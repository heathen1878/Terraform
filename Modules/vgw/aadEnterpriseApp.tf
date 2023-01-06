# Imported Enterprise Application for Azure VPN
resource "azuread_service_principal" "AzureVPN" {
    app_role_assignment_required = true
    application_id = ""
    feature_tags {
        custom_single_sign_on = false
        enterprise = true
        gallery = false
        hide = false
    }
}