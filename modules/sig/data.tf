data "azurerm_shared_image_gallery" "compute_gallery" {
    name                = "Packer"
    resource_group_name = "Packer"
}

data "azurerm_shared_image_versions" "compute_gallery" {
    image_name          = "Windows"
    gallery_name        = "Packer"
    resource_group_name = "Packer"
}

data "azurerm_shared_image_version" "latest_compute_gallery" {
    name                = "1.0.4"
    image_name          = data.azurerm_shared_image_versions.compute_gallery.image_name
    gallery_name        = data.azurerm_shared_image_versions.compute_gallery.gallery_name
    resource_group_name = data.azurerm_shared_image_versions.compute_gallery.resource_group_name
}

