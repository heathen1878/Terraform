variable "record" {
  description = "A map of zones whose nameservers should be changed"
  type = map(object(
    {
      name                = string
      zone_name           = string
      resource_group_name = string
      ttl                 = number
      records             = list(string)
      tags                = map(any)
    }
  ))
}