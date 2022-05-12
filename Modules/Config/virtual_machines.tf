#locals {
#
#    virtual_machine = {
#        workstation = {
#            resource_group_name = azurecaf_name.resourceGroup.result
#            availability_set    = false
#
#        }
#    }
#
#    # ---------------------------------------------------------------------------------------------------------------------
#    # LOCAL CALCULATED
#    # ---------------------------------------------------------------------------------------------------------------------
#
#    virtual_machine_output = {
#        for virtual_machine_key, virtual_machine_value in local.virtual_machine : virtual_machine_key => {
#            resource_group_name        = virtual_machine_value.resource_group_name
#            availability_set           = try(local.virtual_machine[virtual_machine_key].availability_set, false)
#        }
#    }
#
#}
#
