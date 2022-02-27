terraform {
    required_version = "~> 0.14.0"
    required_providers {
        random = {

        }
        azurecaf = {
            source = "aztfmod/azurecaf"
            version = "1.2.10"
        }
    }
}