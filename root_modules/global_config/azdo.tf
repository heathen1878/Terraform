locals {

  # Repositories
  azdo_project_repositories_output = {
    for key, value in var.azdo_project_repositories : key => {
      project        = value.project
      name           = key
      default_branch = lookup(value, "default_branch", "refs/heads/main")
    }
  }

  # Project Features
  azdo_project_features = {
    for key, value in var.azdo_projects : key => {
      boards       = try(index(value.features, "boards"), "disabled")
      repositories = try(index(value.features, "repos"), "disabled")
      pipelines    = try(index(value.features, "pipelines"), "disabled")
      testplans    = try(index(value.features, "testplans"), "disabled")
      artifacts    = try(index(value.features, "artifacts"), "disabled")
    }
  }

  # Projects
  azdo_projects_output = {
    for key, value in var.azdo_projects : key => {
      name        = value.name
      description = value.description
      dockerhub   = value.dockerhub
      features = {
        for features_key, features_value in local.azdo_project_features : features_key => features_value
        if features_key == key
      }
      work_item_template = value.work_item_template
      version_control    = value.version_control
      visibility         = value.visibility
    }
  }

}