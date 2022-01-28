data "template_file" "sshKeys" {
    for_each = var.virtualMachines
    template = file(format("%s/templates/generateSSHKeys.sh.tpl", path.root))
    vars = {
        comment = format("%s%s", each.value.computerName, "SSH Keys")
        filename = each.value.computerName
    }
}

resource "local_file" "sshKeys" {
    for_each = var.virtualMachines
    content = data.template_file.sshKeys[ each.key ].rendered
    filename =  format("%s/scripts/%s.sh", path.root, each.value.computerName)
}

resource "null_resource" "sshKeys" {
    for_each = var.virtualMachines
    provisioner "local-exec" {
        command = local_file.sshKeys[ each.key ].filename
    }  
}