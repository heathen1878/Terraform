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

data "terraform_remote_state" "global_dns_zones" {
  backend = "azurerm"

  config = {
    storage_account_name = var.state_storage_account
    container_name       = format("%s-%s", var.tenant_id, var.location)
    key                  = "global_dns_zones.tfstate"
  }

}
