output "gallery" {
  value = data.azurerm_shared_image_gallery.compute_gallery
}

output "images" {
  value = data.azurerm_shared_image_versions.compute_gallery
}

output "latest_image" {
  value = data.azurerm_shared_image_version.latest_compute_gallery
}
