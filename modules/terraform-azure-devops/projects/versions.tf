terraform {
  required_version = "~> 1.4.0"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.5.0"
    }
  }
}
