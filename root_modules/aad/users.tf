module "aad_users" {
  source = "../../modules/aad/users"

  users = data.terraform_remote_state.global.outputs.aad_users.users

}
