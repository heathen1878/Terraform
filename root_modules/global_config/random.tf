resource "random_uuid" "aad_application" {
  for_each = local.aad_applications
}

