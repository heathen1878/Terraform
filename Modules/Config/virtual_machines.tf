locals {

  virtual_machine = {
    vm1 = {
      availability_set              = false
      managed_availability_set      = true
      platform_fault_domain_count   = 2
      platform_update_domain_count  = 5
      public_ip_address             = true
      private_ip_address_allocation = "dynamic"
      subnet                        = "Workstations" # Name of the subnet, must be defined within virtual_network.tf
      operating_system              = "linux"        # Determines whether azurerm_windows_virtual_machine or azurerm_linux_virtual_machine resource is used.
      vm_hardware_sku               = "Standard_B2ms"
      image_publisher               = ""
      image_offer                   = ""
      image_sku                     = ""
      image_version                 = ""
      kv = [
        "management"
      ]
      resource_group = "demo"
    }
    #vm2 = {
    #    availability_set    = false
    #    managed_availability_set = true
    #    platform_fault_domain_count = 2
    #    platform_update_domain_count = 5
    #    public_ip_address   = true
    #    private_ip_address_allocation = "static"
    #    subnet = "Workstations" # Name of the subnet, must be defined within virtual_network.tf
    #    operating_system = "windows" # Determines whether azurerm_windows_virtual_machine or azurerm_linux_virtual_machine resource is used.
    #    vm_hardware_sku = "Standard_B2ms"         
    #    image_publisher = "" # Get-AzVMImagePublisher -Location 'Location' | Where-Object {$_.PublisherName -like "*MicrosoftWindows*"} or Where-Object {$_.PublisherName -like "*Canonical*"}
    #    image_offer = "" # Get-AzVMImageOffer -Location 'Location' -PublisherName 'Value from Get-AzVMImagePublisher'"
    #    image_sku = "" # Get-AzVMImageSku -Location 'Location' -PublisherName 'Value from Get-AzVMImagePublisher' -Offer 'Value from Get-AzVMImageOffer'"
    #    image_version = "" # Get-AzVMImage -Location 'Location' -PublisherName 'Value from Get-AzVMImagePublisher' -Offer 'Value from Get-AzVMImageOffer' -Sku 'Value from Get-AzVMImageSku'
    #    kv = [
    #    ]
    #}
  }

  # ---------------------------------------------------------------------------------------------------------------------
  # LOCAL CALCULATED
  # ---------------------------------------------------------------------------------------------------------------------

  virtual_machine_output = {
    for virtual_machine_key, virtual_machine_value in local.virtual_machine : virtual_machine_key => {
      availability_set   = virtual_machine_value.availability_set != false ? azurecaf_name.availability_set[virtual_machine_key].result : false
      name               = virtual_machine_value.operating_system == "linux" ? format("%s-%s", azurecaf_name.linux_virtual_machine[virtual_machine_key].result, substr(virtual_machine_key, 2, -1)) : format("%s-%s", azurecaf_name.windows_virtual_machine[virtual_machine_key].result, substr(virtual_machine_key, 2, -1))
      network_adapter    = azurecaf_name.network_adapter[virtual_machine_key].result
      managed_os_disk    = azurecaf_name.managed_os_disk[virtual_machine_key].result
      public_ip_address  = try(azurecaf_name.public_ip_address[virtual_machine_key].result, "")
      private_ip_address = virtual_machine_value.private_ip_address_allocation == "static" ? substr(virtual_machine_key, 2, -1) + 128 : null
      subnet             = virtual_machine_value.subnet
      operating_system   = virtual_machine_value.operating_system
      vm_hardware_sku    = virtual_machine_value.vm_hardware_sku
      computer_name      = virtual_machine_value.operating_system == "linux" ? format("%s-%s", substr(azurecaf_name.linux_virtual_machine[virtual_machine_key].result, 3, -1), substr(virtual_machine_key, 2, -1)) : format("%s-%s", substr(azurecaf_name.windows_virtual_machine[virtual_machine_key].result, 3, -1), substr(virtual_machine_key, 2, -1))
      admin_username     = virtual_machine_value.operating_system == "linux" ? format("%s-adm", azurecaf_name.linux_virtual_machine[virtual_machine_key].name) : format("%s-adm", azurecaf_name.windows_virtual_machine[virtual_machine_key].name)
      admin_password     = random_password.virtual_machine[virtual_machine_key].result
      generate_ssh_keys  = virtual_machine_value.operating_system == "linux" ? true : false
      image_publisher    = virtual_machine_value.operating_system == "linux" ? "Canonical" : "MicrosoftWindowsServer"
      image_offer        = virtual_machine_value.operating_system == "linux" ? "0001-com-ubuntu-server-focal" : "WindowsServer"
      image_sku          = virtual_machine_value.operating_system == "linux" ? "20_04-lts" : "2019-Datacenter"
      image_version      = "Latest"
      kv                 = virtual_machine_value.kv
      resource_group     = lookup(local.virtual_machine[virtual_machine_key], "resource_group", "demo")
    }
  }

}
