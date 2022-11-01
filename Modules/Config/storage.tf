#locals {
#    storage = {
#        storageaccount1 = {
#            name                     = "account1"
#            allow_nested_items_to_be_public = true
#            containers = {
#                repos = {
#                    access_type = "blob"
#                }
#            }
#            lifecycle = {
#                 
#            }
#        }
#        packer_images = {
#            name                     = "packerimages"
#            allow_nested_items_to_be_public = true
#            containers = {
#                images = {
#                    access_type = "private"
#                }
#                tools = {
#                    access_type = "private"
#                }
#            }
#        }
#    }
#
#    # ---------------------------------------------------------------------------------------------------------------------
#    # LOCAL CALCULATED
#    # ---------------------------------------------------------------------------------------------------------------------
#
#    storage_containers = flatten([
#        for account_key, account_value in local.storage :[
#            for container_key, container_value in account_value.containers : {
#                account_key   = account_key
#                container_name = container_key
#                access_type    = container_value.access_type
#            }
#        ] if lookup(account_value, "containers", null) != null
#    ]
#    )
#
#    storage_containers_map = {
#        for container_value in local.storage_containers :
#        format("%s_%s", container_value.account_key, container_value.container_name) => container_value
#    }
#
#    storage_account_output = {
#        for storage_account_key, storage_account_value in local.storage : storage_account_key => {
#            name                             = azurecaf_name.storage_account[storage_account_key].result
#            account_tier                     = lookup(storage_account_value, "account_tier", "Standard")
#            account_replication_type         = lookup(storage_account_value, "account_replication_type", "LRS")
#            allow_nested_items_to_be_public  = lookup(storage_account_value, "allow_nested_items_to_be_public", false)
#            custom_domain                    = lookup(storage_account_value, "custom_domain", {})
#        }
#    }
#
#    
#
#
#}