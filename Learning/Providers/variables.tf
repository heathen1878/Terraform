variable "location" {
    description = "Location name"
    default = "North Europe"
}
variable "subscriptionId" {
    description = "Subscription Id"
    default = ""  
}
variable "environment" {
    description = "Environment: Dev, Test, Prod..."
    default = "Dev"
}
variable "usage" {
    description = "The resource group usage - application or infrastructure"
    default = "usage"
}
variable "tags" {
    description = "Tags required for the resource group"
    default = {
        environment = ""
        applicationName = ""
        location = ""
    }
}