locals {

  azdo_projects = {
    docker = {
      name        = "Docker"
      description = "Contains Docker examples"
      features = [
        "repos"
      ]
    }
    pipelines = {
      name        = "Pipelines"
      description = "Contains all pipeline code"
      dockerhub = [
        "northeuropeacr"
      ]
      features = [
        "repos",
        "pipelines"
      ]
    }
    powershell = {
      name        = "PowerShell"
      description = "Contains PowerShell code"
      features = [
        "repos"
      ]
    }
    powershell_public = {
      name        = "Public PowerShell Modules"
      description = "Contains public PowerShell modules - like a PowerShell Gallery"
      features = [
        "repos",
        "artifacts"
      ]
      visibility = "public"
    }
    shared = {
      name        = "Shared"
      description = "Contains all shared artifacts...pipelines...modules etc."
      features = [
        "repos"
      ]
    }
    terraform = {
      name = "Terraform"
      description = "Contains Terraform code"
      features = [
        "repos"
      ]
    }
  }

  azdo_project_features = {
    for project_key, project_value in local.azdo_projects : project_key => {
      boards       = try(index(project_value.features, "boards"), null)
      repositories = try(index(project_value.features, "repos"), null)
      pipelines    = try(index(project_value.features, "pipelines"), null)
      testplans    = try(index(project_value.features, "testplans"), null)
      artifacts    = try(index(project_value.features, "artifacts"), null)
    }
  }

  azdo_projects_output = {
    for project_key, project_value in local.azdo_projects : project_key => {
      name        = project_value.name
      description = lookup(project_value, "description", "Not defined")
      dockerhub   = lookup(project_value, "dockerhub", [])
      features = {
        for feature_key, feature_value in local.azdo_project_features : feature_key => feature_value
        if feature_key == project_key
      }
      work_item_template = lookup(project_value, "work_item_template", "Agile")
      version_control    = lookup(project_value, "version_control", "Git")
      visibility         = lookup(project_value, "visibility", "private")
    }
  }


}