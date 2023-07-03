locals {

  virtual_machines = {
    #vm1 = {
    #  availability_set              = false
    #  managed_availability_set      = true
    #  platform_fault_domain_count   = 2
    #  platform_update_domain_count  = 5
    #  public_ip_address             = true
    #  private_ip_address_allocation = "dynamic"
    #  subnet                        = "Workstations" # Name of the subnet, must be defined within virtual_network.tf
    #  operating_system              = "linux"        # Determines whether azurerm_windows_virtual_machine or azurerm_linux_virtual_machine resource is used.
    #  vm_hardware_sku               = "Standard_B2ms"
    #  image_publisher               = ""
    #  image_offer                   = ""
    #  image_sku                     = ""
    #  image_version                 = ""
    #  kv = [
    #    "management"
    #  ]
    #  resource_group = "demo"
    #}
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
    for key, value in local.virtual_machines : key => {
      availability_set   = value.availability_set != false ? azurecaf_name.availability_set[key].result : false
      name               = value.operating_system == "linux" ? format("%s-%s", azurecaf_name.linux_virtual_machine[key].result, substr(key, 2, -1)) : format("%s-%s", azurecaf_name.windows_virtual_machine[key].result, substr(key, 2, -1))
      network_adapter    = azurecaf_name.network_adapter[key].result
      managed_os_disk    = azurecaf_name.managed_os_disk[key].result
      public_ip_address  = try(azurecaf_name.public_ip_address[key].result, "")
      private_ip_address = value.private_ip_address_allocation == "static" ? substr(key, 2, -1) + 128 : null
      subnet             = value.subnet
      operating_system   = value.operating_system
      vm_hardware_sku    = value.vm_hardware_sku
      computer_name      = value.operating_system == "linux" ? format("%s-%s", substr(azurecaf_name.linux_virtual_machine[key].result, 3, -1), substr(key, 2, -1)) : format("%s-%s", substr(azurecaf_name.windows_virtual_machine[key].result, 3, -1), substr(key, 2, -1))
      admin_username     = value.operating_system == "linux" ? format("%s-adm", azurecaf_name.linux_virtual_machine[key].name) : format("%s-adm", azurecaf_name.windows_virtual_machine[key].name)
      admin_password     = random_password.virtual_machine[key].result
      generate_ssh_keys  = value.operating_system == "linux" ? true : false
      image_publisher    = value.operating_system == "linux" ? "Canonical" : "MicrosoftWindowsServer"
      image_offer        = value.operating_system == "linux" ? "0001-com-ubuntu-server-focal" : "WindowsServer"
      image_sku          = value.operating_system == "linux" ? "20_04-lts" : "2019-Datacenter"
      image_version      = "Latest"
      kv                 = value.kv
      resource_group     = value.resource_group
    }
  }

}
