## Terraform Command Line

**Init** 

Initialise a working directory be that new code or cloned code from version control e.g. Github.

``terraform
init
``

**Plan** 

Dry run, what is Terrform code going to create, delete, or modify

``terraform
plan
``

**Plan -out** 

Output a deployment plan e.g. 

``terraform 
plan -out deployment_infra_date
``

**Plan -destroy**

Dry run of destroy

``terraform
plan -destroy
``

**Apply**

``terraform
apply
``

**Apply {Plan Name}**

``terraform
apply deployment_infra_date
``

**Apply -target={Resource Name}**



Apply -var variable={variable}

Destroy - remove the resources created by Terraform. 

Providers - shows all providers being used witin the configuration.

Terraform can be coded using native syntax

```terraform
resource "terraform_resource_name" "friendly_name" {
    name = "resource_name"
}
```
or
```json
{
    "resource": {
        "terraform_resource_name": {
            "friendly_name": {
                "name": "resource_name"
            }
        }
    }
}
```