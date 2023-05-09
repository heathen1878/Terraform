variable "tenant_id" {
  description = "AAD tenant id"
  type        = string
}
variable "management_groups" {
  description = "A map of management groups to manage"
  default     = {}
  type = map(object
    (
      {
        display_name  = string
        subscriptions = list(string)
      }
    )
  )
}