module "devops_projects" {
  source = "../../modules/terraform-azure-devops/projects"

  projects = local.devops_projects
}

locals {

  devops_projects = {
    for key, value in data.terraform_remote_state.global_config.outputs.azdo_projects : key => {
      name               = value.name
      visibility         = value.visibility
      version_control    = value.version_control
      work_item_template = value.work_item_template
      description        = value.description
      features = {
        boards       = value.features[key].boards == "disabled" ? "disabled" : "enabled"
        repositories = value.features[key].repositories == "disabled" ? "disabled" : "enabled"
        pipelines    = value.features[key].pipelines == "disabled" ? "disabled" : "enabled"
        testplans    = value.features[key].testplans == "disabled" ? "disabled" : "enabled"
        artifacts    = value.features[key].artifacts == "disabled" ? "disabled" : "enabled"
      }
    }
  }

}