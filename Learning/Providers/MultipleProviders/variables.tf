variable "location" {
    description = "Location name"
    default = "North Europe"
    type = string
}
variable "subscriptionId" {
    description = "Subscription Id"
    default = ""
    type = string 
}
variable "environment" {
    description = "Environment: Dev, Test, Prod..."
    default = "Dev"
    type = string
}
variable "usage" {
    description = "The resource group usage - application or infrastructure"
    default = "usage"
    type = string
}
variable "tags" {
    description = "Tags required for the resource group"
    default = {
        environment = ""
        applicationName = ""
        location = ""
    }
}