locals {

  azdo_projects = {
    docker = {
      name        = "Docker"
      description = "Contains Docker examples"
      features = [
        "repos",
        "pipelines"

      ]
    }
    openhack = {
      name        = "Open Hack"
      description = "Secure Zero Downtime Deployments"
      features = [
        "boards",
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
        "repos",
        "artifacts"
      ]
    }
    terraform_project = {
      name        = "Project learning Terraform"
      description = "Contains Terraform code"
      features = [
        "boards",
        "repos",
        "pipelines"
      ]
    }
  }

  azdo_project_repositories = {
    pipelines = {
      project = "shared"

    }
  }

  ############################
  # Locals - calculated values
  ############################

  # Repositories
  azdo_project_repositories_output = {
    for key, value in local.azdo_project_repositories : key => {
      project        = value.project
      name           = key
      default_branch = lookup(value, "default_branch", "refs/heads/main")
    }
  }

  # Project Features
  azdo_project_features = {
    for key, value in local.azdo_projects : key => {
      boards       = try(index(value.features, "boards"), "disabled")
      repositories = try(index(value.features, "repos"), "disabled")
      pipelines    = try(index(value.features, "pipelines"), "disabled")
      testplans    = try(index(value.features, "testplans"), "disabled")
      artifacts    = try(index(value.features, "artifacts"), "disabled")
    }
  }

  # Projects
  azdo_projects_output = {
    for key, value in local.azdo_projects : key => {
      name        = value.name
      description = lookup(value, "description", "Not defined")
      dockerhub   = lookup(value, "dockerhub", [])
      features = {
        for features_key, features_value in local.azdo_project_features : features_key => features_value
        if features_key == key
      }
      work_item_template = lookup(value, "work_item_template", "Agile")
      version_control    = lookup(value, "version_control", "Git")
      visibility         = lookup(value, "visibility", "private")
    }
  }

}