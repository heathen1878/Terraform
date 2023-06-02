terraform {
  required_version = "~> 1.1.0"
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.3.0"
    }
  }
}
