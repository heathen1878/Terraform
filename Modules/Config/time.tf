resource "time_rotating" "password_rotation" {
  for_each = local.aad_users

  #rotation_days = each.value.expire_secret_after - each.value.rotate_secret_days_before_expiry
  rotation_minutes = each.value.expire_password_after - each.value.rotate_password_days_before_expiry
}

resource "time_offset" "password_expiry" {
  for_each = local.aad_users

  triggers = {
    password_rotation = time_rotating.password_rotation[each.key].id
  }
  #offset_days = each.value.expire_secret_after
  offset_minutes = each.value.expire_password_after
}

resource "time_rotating" "secret_rotation" {
  for_each = local.aad_applications

  #rotation_days = each.value.expire_secret_after - each.value.rotate_secret_days_before_expiry
  rotation_minutes = each.value.expire_secret_after - each.value.rotate_secret_days_before_expiry
}

resource "time_offset" "secret_expiry" {
  for_each = local.aad_applications

  triggers = {
    secret_rotation = time_rotating.secret_rotation[each.key].id
  }
  #offset_days = each.value.expire_secret_after
  offset_minutes = each.value.expire_secret_after
}