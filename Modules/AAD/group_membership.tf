resource "azuread_group_member" "aad_group_memberships" {
  for_each = local.aad_applications_group_membership_map.aad_applications_group_membership

  group_object_id  = azuread_group.mgt-group[each.value.group].id
  member_object_id = azuread_service_principal.aad_application_principal[each.value.membership].object_id
}
