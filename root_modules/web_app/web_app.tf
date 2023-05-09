module "resource_group" {

    source = "../../modules/resource_group"

    

}

module "service_plans" {

  source = "../../modules/service_plan"

  service_plans = data.terraform_remote_state.config.outputs.service_plans

}


