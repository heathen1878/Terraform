#!/bin/bash 

# shellcheck source=./scripts/functions/

# dot source functions
source ./scripts/functions/common.sh
source ./scripts/functions/path.sh
source ./scripts/functions/usage.sh
source ./scripts/functions/apps.sh
source ./scripts/functions/vars.sh

# constants
STORAGE_ACCOUNT="sthmflu45flwcmm"
KEY_VAULT="kv-hmflu45flwcmm"
KEY_VAULT_RG="rg-zayfsvctutjnk-tfconfiguration"
# end constants

# Checks
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
echo -e "$(green)Checking for: $PWD/configuration/environments $(default)"
if ! check_path "$PWD/configuration/environments"; then
    return 1
fi

# check for root modules directory
echo -e "$(green)Checking for: $PWD/root_modules/ $(default)"
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

    "global_config")
    
    # global configuration lives within the tenant id directory
    if check_path "$PWD/configuration/environments/$ARM_TENANT_ID"; then
        echo "$ARM_TENANT_ID exists"
    else
        echo "Creating $ARM_TENANT_ID directory"
        mkdir "$PWD/configuration/environments/$ARM_TENANT_ID"
    fi

    # check for deployment directory within the namespace-environment directory
    if check_path "$PWD/configuration/environments/$ARM_TENANT_ID/$DEPLOYMENT_NAME"; then
        echo "$PWD/configuration/environments/$ARM_TENANT_ID/$DEPLOYMENT_NAME"
    else
        echo "Creating $DEPLOYMENT_NAME in $ARM_TENANT_ID"
        mkdir "$PWD/configuration/environments/$ARM_TENANT_ID/$DEPLOYMENT_NAME"
        mkdir "$PWD/configuration/environments/$ARM_TENANT_ID/$DEPLOYMENT_NAME/plans"
    fi

    TERRAFORM_ENV="$PWD/configuration/environments/$ARM_TENANT_ID/$DEPLOYMENT_NAME"
    TF_DATA_DIR=$TERRAFORM_ENV/.terraform
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
        mkdir "$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT/$LOCATION/$DEPLOYMENT_NAME/plans"
    fi

    TERRAFORM_ENV="$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT/$LOCATION/$DEPLOYMENT_NAME"
    TF_DATA_DIR=$TERRAFORM_ENV/.terraform
    ;;

esac

# check for the container within the storage account
CONTAINER_EXISTS=$(az storage container exists --name "$NAMESPACE_ENVIRONMENT-$LOCATION" --account-name $STORAGE_ACCOUNT --auth-mode login --subscription "$MGMT_SUBSCRIPTION_ID" | jq -rc .exists)
if [ "$CONTAINER_EXISTS" = "false" ]; then
    az storage container create --auth-mode login --account-name $STORAGE_ACCOUNT --name "$NAMESPACE_ENVIRONMENT-$LOCATION" > /dev/null 2>&1
fi

STATE_ACCOUNT=$STORAGE_ACCOUNT
STATE_CONTAINER="$NAMESPACE_ENVIRONMENT-$LOCATION"
STATE_FILE="$DEPLOYMENT_NAME.tfstate"

# end checks

# flow
output_configuration_name "$NAMESPACE_ENVIRONMENT" "$DEPLOYMENT_NAME" "$LOCATION"

# deployment specific environment variables
case $DEPLOYMENT_NAME in

    cloudflare)
    # export cloudflare specific environment variables
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

# set env.tfvars values for Terraform
cat <<EOF >"$TERRAFORM_ENV/env.tfvars"
bootstrap={
    key_vault={
        resource_group="$KEY_VAULT_RG"
        name="$KEY_VAULT"
    }
}
environment = "$ENVIRONMENT"
location = "$LOCATION"
management_subscription = "$MGMT_SUBSCRIPTION_ID"
namespace = "$NAMESPACE"
tenant_id = "$ARM_TENANT_ID"
EOF


# export variables
export ARM_SUBSCRIPTION_ID
export ARM_ACCESS_KEY
export ENVIRONMENT
export LOCATION
export KEY_VAULT
export KEY_VAULT_RG
export MANAGEMENT_SUBSCRIPTION_ID
export NAMESPACE
export STATE_ACCOUNT
export STATE_CONTAINER
export STATE_FILE
export TERRAFORM_DEPLOYMENT
export TERRAFORM_ENV
export TF_DATA_DIR
# end flow
