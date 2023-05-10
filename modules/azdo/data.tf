data "terraform_remote_state" "config" {
  backend = "azurerm"

  config = {
    storage_account_name = "sthn37mgfywa7g4"
    container_name       = format("%s-%s-%s", var.namespace, var.environment, replace(lower(var.location), " ", "-"))
    key                  = "config.tfstate"
  }

}

data "terraform_remote_state" "container_registry" {
  backend = "azurerm"

  config = {
    storage_account_name = "sthn37mgfywa7g4"
    container_name       = format("%s-%s-%s", var.namespace, var.environment, replace(lower(var.location), " ", "-"))
    key                  = "container_registry.tfstate"
  }

}

data "terraform_remote_state" "global" {
  backend = "azurerm"

  config = {
    storage_account_name = "sthn37mgfywa7g4"
    container_name       = var.tenant_id
    key                  = "global.tfstate"
  }
}

