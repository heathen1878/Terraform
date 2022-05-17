# Virtual Machine module

## Linux VMs
 Linux VMs use a SSH key for authentication. The Terraform will create a private and public key pair and store them in Key Vault but before you run the Virtual Machine module the public key must be downloaded to /keys within the root module. 

```bash
az keyvault secret download --name 'secret name' --vault-name 'key vault name' --file ./keys/id_rsa.pub
```

The above could be incorporated into a DevOps pipeline too...

The private SSH key would be downloaded to the local machine, then you can connect to the Linux VM using something like: 
```bash
ssh admin_username@azure_vm_ip_address_or_dns_name -i ~/.ssh/ssh_private_key
```