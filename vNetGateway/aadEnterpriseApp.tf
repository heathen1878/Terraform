# Imported Enterprise Application for Azure VPN
resource "azuread_service_principal" "AzureVPN" {
    app_role_assignment_required = true
    application_id = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    feature_tags {
        custom_single_sign_on = false
        enterprise = true
        gallery = false
        hide = false
    }
}