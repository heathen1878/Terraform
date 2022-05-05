resource "time_rotating" "secret_rotation" {
  for_each = data.terraform_remote_state.aad.outputs.aad_applications

  rotation_days = each.value.expire_secret_after - each.value.rotate_secret_days_before_expiry
}

resource "time_offset" "secret_expiry" {
  for_each = data.terraform_remote_state.aad.outputs.aad_applications

  triggers = {
    password_rotation = time_rotating.secret_rotation[each.key].id
  }
  offset_days = each.value.expire_secret_after
}