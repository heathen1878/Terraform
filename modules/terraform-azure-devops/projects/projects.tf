resource "azuredevops_project" "devops_projects" {
  for_each = var.projects

  name               = each.value.name
  visibility         = each.value.visibility
  version_control    = each.value.version_control
  work_item_template = each.value.work_item_template
  description        = each.value.description
  features = {
    boards       = each.value.features.boards
    repositories = each.value.features.repositories
    pipelines    = each.value.features.pipelines
    testplans    = each.value.features.testplans
    artifacts    = each.value.features.artifacts
  }
}
