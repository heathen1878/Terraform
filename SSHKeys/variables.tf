variable "virtualMachines" {
    description = "Virtual Machines and their associated configurations"
    type = map
    default = {
        VM1 = {
            computerName = ""
            subnet = ""
            ipaddress = ""
            sku = ""
            username = ""
        }
    }
}