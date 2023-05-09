resource "azuredevops_project" "devops_projects" {
  for_each = data.terraform_remote_state.config.outputs.azdo_projects

  name               = each.value.name
  visibility         = each.value.visibility
  version_control    = each.value.version_control
  work_item_template = each.value.work_item_template
  description        = each.value.description
  features = {
    boards       = each.value.features[each.key].boards != null ? "enabled" : "disabled"
    repositories = each.value.features[each.key].repositories != null ? "enabled" : "disabled"
    pipelines    = each.value.features[each.key].pipelines != null ? "enabled" : "disabled"
    testplans    = each.value.features[each.key].testplans != null ? "enabled" : "disabled"
    artifacts    = each.value.features[each.key].artifacts != null ? "enabled" : "disabled"
  }
}
