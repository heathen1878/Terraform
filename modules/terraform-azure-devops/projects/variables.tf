variable "projects" {
  description = "A map of projects to create within Azure DevOps"
  type = map(object(
    {
      name               = string
      visibility         = string
      version_control    = string
      work_item_template = string
      description        = string
      features = object(
        {
          boards       = string
          repositories = string
          pipelines    = string
          testplans    = string
          artifacts    = string
        }
      )
    }
  ))
}