variable "resource_groups" {
  description = "LA map of resource groups"
  default     = {}
  type        = map(object(
    {
      name = string
      location = string
      tags = map(any)
    }
  ))
}