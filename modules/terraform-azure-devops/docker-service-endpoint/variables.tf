variable "docker_service_endpoint" {
  description = "A map of docker / acr service connections"
  type = map(object({
    project_id            = string
    description           = string
    service_endpoint_name = string
    docker_registry       = string
    docker_username       = string
    docker_password       = string
    registry_type         = optional(string, "Others")
  }))
}