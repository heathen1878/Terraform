locals {

  ssh_keys_to_download = flatten([
        for virtual_machine_key, virtual_machine_value in data.terraform_remote_state.config.outputs.virtual_machines : [
            for virtual_machine_kv_value in virtual_machine_value.kv : {
                user       = virtual_machine_value.admin_username
                filename   = virtual_machine_value.admin_username
                kv         = virtual_machine_kv_value
            }
            
        ]
        if virtual_machine_value.operating_system == "linux"
    ])

    ssh_keys_to_download_map = {
        for virtual_machine_key, virtual_machine_value in local.ssh_keys_to_download : format("%s_ssh_%s", virtual_machine_value.filename, virtual_machine_value.kv) => virtual_machine_value
    }

}

resource "azurerm_resource_group" "resource_group" {
    name = data.terraform_remote_state.config.outputs.virtual_machine_resource_group
    location = var.location
    tags = merge(var.tags, {
        location = var.location
        environment = var.environment
        }
    )
}

resource "azurerm_availability_set" "availability_set" {
    for_each = {
        for virtual_machine_key, virtual_machine_value in data.terraform_remote_state.config.outputs.virtual_machines : virtual_machine_key => virtual_machine_value
        if virtual_machine_value.availability_set != "false"
    }

    name = each.value.availability_set
    resource_group_name = azurerm_resource_group.resource_group.name
    location = var.location
    tags = merge(var.tags, {
        location = var.location
        environment = var.environment
        computerName = each.value.computer_name
        }
    )

}

resource "azurerm_public_ip" "public_ip_address" {
    for_each = {
        for virtual_machine_key, virtual_machine_value in data.terraform_remote_state.config.outputs.virtual_machines : virtual_machine_key => virtual_machine_value
        if virtual_machine_value.public_ip_address != ""
    }

    name = each.value.public_ip_address
    resource_group_name = azurerm_resource_group.resource_group.name
    location = var.location
    allocation_method = "Dynamic"
    tags = merge(var.tags, {
        location = var.location
        environment = var.environment
        computerName = each.value.computer_name
        }
    )
}

resource "azurerm_network_interface" "network_adapter" {
  for_each = data.terraform_remote_state.config.outputs.virtual_machines
  name = each.value.network_adapter
  resource_group_name = azurerm_resource_group.resource_group.name
  location = var.location
  ip_configuration {
    name = format("%s-%s%s", each.value.network_adapter, substr(each.key, 2, -1), "-nic-ipconfig")
    subnet_id = data.terraform_remote_state.networking.outputs.subnets[each.value.subnet].id
    private_ip_address_allocation = each.value.private_ip_address != null ? "Static" : "Dynamic"
    private_ip_address = each.value.private_ip_address != null ? cidrhost(data.terraform_remote_state.networking.outputs.subnets[each.value.subnet].address_prefix, each.value.private_ip_address) : null
    public_ip_address_id = each.value.public_ip_address != "" ? azurerm_public_ip.public_ip_address[each.key].id : null
  }
  tags = merge(var.tags, {
        location = var.location
        environment = var.environment
        computerName = each.value.computer_name
        }
    )
}

resource "azurerm_windows_virtual_machine" "virtual_machine" {
    for_each = {
        for virtual_machine_key, virtual_machine_value in data.terraform_remote_state.config.outputs.virtual_machines : virtual_machine_key => virtual_machine_value
        if virtual_machine_value.operating_system == "windows"
    }

    name = each.value.name
    resource_group_name = azurerm_resource_group.resource_group.name
    location = var.location
    size = each.value.vm_hardware_sku
    network_interface_ids = [
      azurerm_network_interface.network_adapter[each.key].id
    ]
    availability_set_id = each.value.availability_set != "false" ? azurerm_availability_set.availability_set[each.key].id : null
    computer_name = each.value.computer_name
    admin_username = each.value.admin_username
    admin_password = each.value.admin_password
    source_image_reference {
      publisher = each.value.image_publisher
      offer = each.value.image_offer
      sku = each.value.image_sku
      version = each.value.image_version
    }
    os_disk {
      name = format("%s-%s", each.value.managed_os_disk, substr(each.key, 2, -1))
      storage_account_type = "Standard_LRS"
      caching = "ReadWrite"
    }
    identity {
      type = "SystemAssigned"
    }
    tags = merge(var.tags, {
        location = var.location
        environment = var.environment
        computerName = each.value.computer_name
        }
    )
}

resource "null_resource" "download_ssh_key" {
  for_each = local.ssh_keys_to_download_map

  triggers = {
    # Always download...
    run = timestamp()
  }

}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  for_each = {
      for virtual_machine_key, virtual_machine_value in data.terraform_remote_state.config.outputs.virtual_machines : virtual_machine_key => virtual_machine_value
        if virtual_machine_value.operating_system == "linux"
  }

  name = each.value.name
  resource_group_name = azurerm_resource_group.resource_group.name
  location = var.location
  size = each.value.vm_hardware_sku
  network_interface_ids = [
    azurerm_network_interface.network_adapter[each.key].id
  ]
  availability_set_id = each.value.availability_set != "false" ? azurerm_availability_set.availability_set[each.key].id : null
  computer_name = each.value.computer_name
  admin_username = each.value.admin_username
  admin_ssh_key {
    username = each.value.admin_username
    public_key = file(format("%s/keys/%s.pub", path.root, each.value.admin_username))
  }   
  source_image_reference {
    publisher = each.value.image_publisher
    offer = each.value.image_offer
    sku = each.value.image_sku
    version = each.value.image_version
  }
  os_disk {
    name = format("%s-%s", each.value.managed_os_disk, substr(each.key, 2, -1))
    storage_account_type = "Standard_LRS"
    caching = "ReadWrite"
  }
  identity {
    type = "SystemAssigned"
  }
  tags = merge(var.tags, 
    {
      location = var.location
      environment = var.environment
      computerName = each.value.computer_name
    }
  )

  depends_on = [
    null_resource.download_ssh_key
  ]

}
