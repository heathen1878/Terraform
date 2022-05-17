resource "random_password" "aad_application" {
  for_each = data.terraform_remote_state.config.outputs.aad_applications

  length = 24
  special = true

  keepers = {
    password_rotation = time_rotating.secret_rotation[each.key].id
  }

}