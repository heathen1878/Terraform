#!/bin/bash 

# shellcheck source=./scripts/functions/usage.sh
source ./scripts/functions/usage.sh

# constants
STORAGE_ACCOUNT="sthmflu45flwcmm"
KEY_VAULT="kv-hmflu45flwcmm"
KEY_VAULT_RG="rg-zayfsvctutjnk-tfconfiguration"
# end constants

# Checks

# clear any environment variables set previously
unset NAMESPACE
unset ENVIRONMENT
unset LOCATION

# check script started with dot sourcing
if [ "$BASH_SOURCE" == "$0" ]; then
    show_usage
fi

# check script for input parameters
if (( $# == 0 )); then
    show_usage
fi

# check whether an alternative location has been specified
if [ -z "$3" ]; then
    LOCATION=northeurope
else
    LOCATION="$(echo "$3" | awk '{print tolower($0)}')"
fi

# check the namespace-environment parameter is correct
case $1 in
    "global")
    # global namespace specified   
    NAMESPACE="$(echo "$1" | awk -F'-' '{print tolower($1)}')"
    NAMESPACE_ENVIRONMENT="$(echo "$1" | awk '{print tolower($0)}')"
    ;;

    *)
    # catch namespace and environment
    if ! check_namespace_environment_parameter "$1"; then
        return 1
    fi
    NAMESPACE="$(echo "$1" | awk -F'-' '{print tolower($1)}')"
    ENVIRONMENT="$(echo "$1" | awk -F'-' '{print tolower($2)}')"
    NAMESPACE_ENVIRONMENT="$(echo "$1" | awk '{print tolower($0)}')"
    ;;
esac

# Check whether the namespace-environment has an associated subscription
ARM_SUBSCRIPTION_ID="$(az keyvault secret show --name "$NAMESPACE_ENVIRONMENT" --vault-name "$KEY_VAULT" --query value --output json 2> /dev/null | sed -e 's/^\"//' -e 's/\"$//')"
if [ -z "$ARM_SUBSCRIPTION_ID" ]; then
    echo -e "$(red)Cannot find subscription for: $NAMESPACE_ENVIRONMENT $(default)"
    return 1
fi

# Check whether the namespace-environment has an associated subscription
MGMT_SUBSCRIPTION_ID="$(az keyvault secret show --name MGMT --vault-name "$KEY_VAULT" --query value --output json 2> /dev/null | sed -e 's/^\"//' -e 's/\"$//')"
if [ -z "$MGMT_SUBSCRIPTION_ID" ]; then
    echo -e "$(red)Cannot find a management subscription id$(default)"
    return 1
fi

# check whether can get the storage account access key
ARM_ACCESS_KEY="$(az storage account keys list --account-name "$STORAGE_ACCOUNT" --subscription "$MGMT_SUBSCRIPTION_ID" | jq -rc '[.[].value][0]')"
if [ -z "$ARM_ACCESS_KEY" ]; then
    echo -e "$(red)Failed to retrieve the storage account access key$(default)"
    return 1
fi

# check for environment configuration directory
if ! check_path "$PWD/configuration/environments"; then
    return 1
fi

# check for root modules directory
if ! check_path "$PWD/root_modules/"; then
    return 1
fi

# check for deployment name module
if ! check_deployment_parameter "$2"; then
    return 1
fi
DEPLOYMENT_NAME="$(echo "$2" | awk '{print tolower($0)}')"
TERRAFORM_DEPLOYMENT="$PWD/root_modules/$DEPLOYMENT_NAME"

# check for global or namespace-environment configuration directory
case $DEPLOYMENT_NAME in

    global*)
    
    # global configuration lives within the tenant id directory
    if ! check_path "$PWD/configuration/environments/$ARM_TENANT_ID"; then
        echo -e "$(green)Creating $ARM_TENANT_ID directory$(default)"
        mkdir "$PWD/configuration/environments/$ARM_TENANT_ID"
    fi

    if ! check_path "$PWD/configuration/environments/$ARM_TENANT_ID/$LOCATION"; then
        echo -e "$(green)creating $LOCATION directory within $ARM_TENANT_ID$(default)"
        mkdir "$PWD/configuration/environments/$ARM_TENANT_ID/$LOCATION"
    fi

    # check for deployment directory within the namespace-environment directory
    if ! check_path "$PWD/configuration/environments/$ARM_TENANT_ID/$LOCATION/$DEPLOYMENT_NAME"; then
        echo -e "$(green)Creating $DEPLOYMENT_NAME in $ARM_TENANT_ID/$LOCATION$(default)"
        mkdir "$PWD/configuration/environments/$ARM_TENANT_ID/$LOCATION/$DEPLOYMENT_NAME"
    fi

    # Always create the plans directory
    mkdir "$PWD/configuration/environments/$ARM_TENANT_ID/$LOCATION/$DEPLOYMENT_NAME/plans"

    TERRAFORM_ENV="$PWD/configuration/environments/$ARM_TENANT_ID/$LOCATION/$DEPLOYMENT_NAME"
    TF_DATA_DIR=$TERRAFORM_ENV/.terraform

    CONTAINER_NAME="$ARM_TENANT_ID-$LOCATION"
    ;;

    *)
    # environment configuration lives within the namespace-environment specific directory
    if ! check_path "$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT"; then
        echo -e "$(green)creating $NAMESPACE_ENVIRONMENT directory$(default)"
        mkdir "$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT"
    fi

    if ! check_path "$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT/$LOCATION"; then
        echo -e "$(green)creating $LOCATION directory within $NAMESPACE_ENVIRONMENT$(default)"
        mkdir "$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT/$LOCATION"
    fi

     # check for deployment directory within the namespace-environment directory
    if ! check_path "$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT/$LOCATION/$DEPLOYMENT_NAME"; then
        echo -e "$(green)Creating $DEPLOYMENT_NAME in $NAMESPACE_ENVIRONMENT/$LOCATION/$(default)"
        mkdir "$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT/$LOCATION/$DEPLOYMENT_NAME"
    fi

    # Always create the plans directory
    mkdir "$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT/$LOCATION/$DEPLOYMENT_NAME/plans"

    TERRAFORM_ENV="$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT/$LOCATION/$DEPLOYMENT_NAME"
    TF_DATA_DIR=$TERRAFORM_ENV/.terraform

    CONTAINER_NAME="$NAMESPACE_ENVIRONMENT-$LOCATION"
    ;;

esac

# check for the container within the storage account
CONTAINER_EXISTS=$(az storage container exists --name "$CONTAINER_NAME" --account-name $STORAGE_ACCOUNT --auth-mode login --subscription "$MGMT_SUBSCRIPTION_ID" | jq -rc .exists)
if [ "$CONTAINER_EXISTS" = "false" ]; then
    az storage container create --auth-mode login --account-name $STORAGE_ACCOUNT --name "$CONTAINER_NAME" > /dev/null 2>&1
fi

STATE_ACCOUNT=$STORAGE_ACCOUNT
STATE_CONTAINER="$CONTAINER_NAME"
STATE_FILE="$DEPLOYMENT_NAME.tfstate"

# end checks

# flow
output_configuration_name "$NAMESPACE_ENVIRONMENT" "$DEPLOYMENT_NAME" "$LOCATION"

# deployment specific environment variables
case $DEPLOYMENT_NAME in

    global*)
    # export cloudflare specific environment variables
    AZDO_ORG_SERVICE_URL="$(az keyvault secret show --name azdo-service-url --vault-name $KEY_VAULT --query value --output json 2> /dev/null | sed -e 's/^\"//' -e 's/\"$//')"
    export AZDO_ORG_SERVICE_URL
    AZDO_PERSONAL_ACCESS_TOKEN="$(az keyvault secret show --name azdo-pat-token-tf --vault-name $KEY_VAULT --query value --output json 2> /dev/null | sed -e 's/^\"//' -e 's/\"$//')"
    export AZDO_PERSONAL_ACCESS_TOKEN
    CLOUDFLARE_API_TOKEN="$(az keyvault secret show --name cloudflare-api-token --vault-name $KEY_VAULT --query value --output json 2> /dev/null | sed -e 's/^\"//' -e 's/\"$//')"
    export CLOUDFLARE_API_TOKEN
    IONOS_API_KEY=$(az keyvault secret show --name ionos-api-token --vault-name $KEY_VAULT --query value --output json 2> /dev/null | sed -e 's/^\"//' -e 's/\"$//')
    export IONOS_API_KEY
    ;;
    *)
    CLOUDFLARE_API_TOKEN="$(az keyvault secret show --name cloudflare-api-token --vault-name $KEY_VAULT --query value --output json 2> /dev/null | sed -e 's/^\"//' -e 's/\"$//')"
    export CLOUDFLARE_API_TOKEN
    ;;

esac

# set backend.tfvars values for Terraform AzureRM provider
cat <<EOF >"$TERRAFORM_ENV/backend.tfvars"
storage_account_name = "$STATE_ACCOUNT"
container_name       = "$STATE_CONTAINER"
key                  = "$STATE_FILE"
EOF

# set env.tfvars values for the config module; will only run on the first run.
if [ ! -f "$TERRAFORM_ENV/env.tfvars" ] && [[ "$DEPLOYMENT_NAME" == "config" ]]; then
cat <<EOF >"$TERRAFORM_ENV/env.tfvars"
bootstrap={
    key_vault={
        resource_group="$KEY_VAULT_RG"
        name="$KEY_VAULT"
    }
}
management_subscription = "$MGMT_SUBSCRIPTION_ID"
virtual_networks={
    environment = {
      resource_group = "environment"
      address_space = [
        "10.0.0.0/16"
      ]
      dns_servers = []
      peers = []
    }
}
EOF

echo -e "$(yellow)WARNING$(warning):$(default)"
echo -e "$(yellow)Please check the default IP address space 10.0.0.0/16 does not $(red)overlap$(yellow) with any other networks. If it does please$(default)"
echo -e "$(yellow)update env.tfvars in $TERRAFORM_ENV$(default)"

elif [ ! -f "$TERRAFORM_ENV/env.tfvars" ] && [[ "$DEPLOYMENT_NAME" == "global_config" ]]; then
# set env.tfvars values for global_config module; will only run on the first run.
cat <<EOF >"$TERRAFORM_ENV/env.tfvars"
bootstrap={
    key_vault={
        resource_group="$KEY_VAULT_RG"
        name="$KEY_VAULT"
    }
}

management_subscription = "$MGMT_SUBSCRIPTION_ID"
virtual_networks={
    global = {
        resource_group = "global"
      address_space = [
        "10.0.0.0/16"
      ]
      dns_servers = []
      peers = []
    }
}
EOF

echo -e "$(yellow)WARNING$(warning):$(default)"
echo -e "$(yellow)Please check the default IP address space 10.0.0.0/16 does not $(red)overlap$(yellow) with any other networks. If it does please$(default)"
echo -e "$(yellow)update env.tfvars in $TERRAFORM_ENV$(default)"

elif [[ "$DEPLOYMENT_NAME" != *"config" ]]; then
cat <<EOF >"$TERRAFORM_ENV/env.tfvars"
EOF
fi

# export variables
TF_VAR_environment="$ENVIRONMENT"
export TF_VAR_environment
TF_VAR_location="$LOCATION"
export TF_VAR_location
export LOCATION
TF_VAR_namespace="$NAMESPACE"
export TF_VAR_namespace
TF_VAR_state_storage_account="$STATE_ACCOUNT"
export TF_VAR_state_storage_account
export ARM_SUBSCRIPTION_ID
export ARM_ACCESS_KEY
export DEPLOYMENT_NAME
export KEY_VAULT
export KEY_VAULT_RG
export MANAGEMENT_SUBSCRIPTION_ID
export NAMESPACE_ENVIRONMENT
export STATE_ACCOUNT
export STATE_CONTAINER
export STATE_FILE
export TERRAFORM_DEPLOYMENT
export TERRAFORM_ENV
export TF_DATA_DIR
# end flow
