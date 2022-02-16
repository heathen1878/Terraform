output "subscriptionAndEnvironmentAndLocationUnique" {
    value = random_id.subscriptionAndEnvironmentAndLocationUnique.id
}
output "subscriptionAndEnvironmentAndLocationUnique_charlimitation" {
    value = random_id.subscriptionAndEnvironmentAndLocationUnique_charlimitation.id
}
output "subscriptionAndLocationUnique" {
    value = random_id.subscriptionAndLocationUnique.id
}
output "resourceGroupUnique" {
    value = random_id.resourceGroupUnique.id
}
output "azurecaf_name_resourceGroupName" {
    value = azurecaf_name.resourceGroup.result
}
output "azurecaf_name_networkSecurityGroup" {
    value = azurecaf_name.networkSecurityGroup.result
}
output "nsgRules" {
    value = var.nsgRules
}
output "subnetsWithNsgs_map" {
    value = local.subnetsWithNsgs_map
}
output "nsgRules_map" {
    value = local.nsgRules_map
}