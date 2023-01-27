resource "time_rotating" "secret_rotation" {
  for_each = local.aad_applications_config_output

  rotation_days = each.value.expire_secret_after - each.value.rotate_secret_days_before_expiry
}

resource "time_offset" "secret_expiry" {
  for_each = local.aad_applications_config_output

  triggers = {
    password_rotation = time_rotating.secret_rotation[each.key].id
  }
  offset_days = each.value.expire_secret_after
}