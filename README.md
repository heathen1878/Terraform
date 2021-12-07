# Terraform

[Learnings from A Cloud Guru](https://learn.acloud.guru/course/using-terraform-to-manage-applications-and-infrastructure/dashboard)

## Terraform Cli

Init - Initialise a working directory be that new code or cloned code from version control e.g. Github.

Plan **Dry run, what is Terrform code going to create, delete, or modifiy**

Plan -out output a deployment plan

Plan -destroy dry run of destroy

Apply **run for real**

Apply {Plan Name}

Apply -target={Resource Name}

Apply -var variable={variable}

Destroy - remove the resources created by Terraform. 

Providers - shows all providers being used witin the configuration.

[Terraform Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

[Local authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)

[MSI authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/managed_service_identity)

[SP authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_certificate)

## Terraform state
Lab / dev - local state is fine whereas in production environments state should be stored remotely.

