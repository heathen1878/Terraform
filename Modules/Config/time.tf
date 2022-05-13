resource "time_rotating" "password_rotation" {
  for_each = local.aad_users

  rotation_days = each.value.expire_password_after - each.value.rotate_password_days_before_expiry
}

resource "time_offset" "password_expiry" {
  for_each = local.aad_users

  triggers = {
    password_rotation = time_rotating.password_rotation[each.key].id
  }
  
  offset_days = each.value.expire_password_after
}