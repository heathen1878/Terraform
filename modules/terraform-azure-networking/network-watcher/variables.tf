variable "network_watcher" {
  description = "A map of network watcher configuration"
  type = map(object(
    {
      name                = string
      resource_group_name = string
      location            = string
      tags                = map(any)
    }
  ))
}