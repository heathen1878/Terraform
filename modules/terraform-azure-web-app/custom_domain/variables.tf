variable "custom_domains" {
    description = "A map of custom domain mappings"
    type = map(object(
        {
            hostname = string
            app_service_name = string
            resource_group_name = string
            ssl_state = optional(string)
            thumbprint = optional(string)
        }
    ))
}