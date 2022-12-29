resource "azuread_group_member" "aad_application_azdo_group_memberships" {
  for_each = data.terraform_remote_state.config.outputs.aad_application_group_membership

  group_object_id  = azuread_group.mgt-azdo-group[each.value.group].id
  member_object_id = azuread_service_principal.aad_application_principal[each.value.membership].object_id
}

resource "azuread_group_member" "aad_user_azdo_group_membership" {
  for_each = data.terraform_remote_state.config.outputs.aad_user_group_membership

  group_object_id  = azuread_group.mgt-azdo-group[each.value.group].id
  member_object_id = azuread_user.mgt_aad_user[each.value.membership].object_id
}

#resource "azuread_group_member" "aad_application_kv_group_memberships" {
#  for_each         = data.terraform_remote_state.config.outputs.aad_application_group_membership
#
#  group_object_id  = azuread_group.mgt-kv-group[each.value.group].id
#  member_object_id = azuread_service_principal.aad_application_principal[each.value.membership].object_id
#}

#resource "azuread_group_member" "aad_user_kv_group_membership" {
#  for_each         = data.terraform_remote_state.config.outputs.aad_user_group_membership
#
#  group_object_id  = azuread_group.mgt-kv-group[each.value.group].id
#  member_object_id = azuread_user.mgt_aad_user[each.value.membership].object_id
#}

