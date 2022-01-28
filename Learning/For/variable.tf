variable "mymap" {
    description = "a map"
    type = map
    default = {
        "plan1" = {
            name = "name1"
            id = "/sub/subid/resourcegroup/..."
            resource_group_name = "resource_group"
        },
        "plan2" = {
            name = "name2"
            id = "/sub/subid/resourcegroup/..."
            resource_group_name = "resource_group"
        }
    }
}