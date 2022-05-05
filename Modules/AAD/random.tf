resource "random_uuid" "aad_applications" {
  for_each = local.aad_applications
}

resource "random_password" "aad_user" {
  for_each = local.aad_users

  length = 24
  special = true

  keepers = {
    password_rotation = time_rotating.password_rotation[each.key].id
  }

}