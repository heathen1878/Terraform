variable "zones" {
  description = "A map of public DNS zones"
  type = map(object(
    {
      name                = string
      resource_group_name = string
      tags                = map(any)
    }
  ))
}