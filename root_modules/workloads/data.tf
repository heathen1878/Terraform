data "terraform_remote_state" "config" {
  backend = "azurerm"

  config = {
    storage_account_name = var.state_storage_account
    container_name       = format("%s-%s-%s", var.namespace, var.environment, var.location)
    key                  = "config.tfstate"
  }

}

data "terraform_remote_state" "infrastructure" {
  backend = "azurerm"

  config = {
    storage_account_name = var.state_storage_account
    container_name       = format("%s-%s-%s", var.namespace, var.environment, var.location)
    key                  = "infrastructure.tfstate"
  }

}

data "azurerm_key_vault_certificate" "lets_encrypt_certificate" {
  for_each = data.terraform_remote_state.config.outputs.certificate_name

  name         = each.value.name
  key_vault_id = data.terraform_remote_state.infrastructure.outputs.key_vault["frontend_certificates"].output.id
}