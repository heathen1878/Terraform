resource "time_rotating" "password_rotation" {
  for_each = local.aad_users

  rotation_days = try(each.value.expire_password_after, 90) - try(each.value.rotate_password_days_before_expiry, 14)
}

resource "time_offset" "password_expiry" {
  for_each = local.aad_users

  triggers = {
    password_rotation = time_rotating.password_rotation[each.key].id
  }

  offset_days = try(each.value.expire_password_after, 90)
}