data "terraform_remote_state" "config" {
  backend = "azurerm"

  config = {
    storage_account_name = var.state_storage_account
    container_name       = format("%s-%s-%s", var.namespace, var.environment, var.location)
    key                  = "config.tfstate"
  }

}

#data "azuread_service_principal" "microsoft_web_app" {
#  application_id = "abfa0a7c-a6b6-4736-8310-5855508787cd"
#}
