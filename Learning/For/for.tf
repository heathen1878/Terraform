locals {
    localvar = {
        newmap = [ 
            for map_key, map_value in var.mymap : {
                name = map_value.name
                id = map_value.id
            }
        ]
    }
}

output "values" {
    value = local.localvar
}