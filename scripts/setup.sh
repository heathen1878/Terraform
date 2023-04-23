#!/bin/bash 

# shellcheck source=./scripts/functions

# dot source functions
source ./scripts/functions/common.sh
source ./scripts/functions/path.sh
source ./scripts/functions/usage.sh
source ./scripts/functions/apps.sh
source ./scripts/functions/vars.sh

# Checks
# check script started with dot sourcing
if [ "$BASH_SOURCE" == "$0" ]; then
    show_usage
fi

# check script for input parameters
if (( $# == 0 )); then
    show_usage
fi

if ! check_for_terraform_executable; then
    exit 1
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
        exit 1
    fi
    NAMESPACE="$(echo "$1" | awk -F'-' '{print tolower($1)}')"
    ENVIRONMENT="$(echo "$1" | awk -F'-' '{print tolower($2)}')"
    NAMESPACE_ENVIRONMENT="$(echo "$1" | awk '{print tolower($0)}')"
    ;;
esac

# check for environment configuration directory
echo -e "$(green)Checking for: $PWD/configuration/environments $(default)"
if ! check_path "$PWD/configuration/environments"; then
    exit 1
fi

# check for deployment name module
if ! check_deployment_parameter "$2"; then
    exit 1
fi
DEPLOYMENT_NAME="$(echo "$2" | awk '{print tolower($0)}')"

# check for global or namespace-environment configuration directory
case $2 in

    "global_config")
    
    # global configuration lives within the tenant id directory
    if check_path "$PWD/configuration/environments/$ARM_TENANT_ID"; then
        echo "$ARM_TENANT_ID exists"
    else
        echo "Creating $ARM_TENANT_ID directory"
    fi

    TERRAFORM_ENV="$PWD/configuration/environments/$ARM_TENANT_ID"
    ;;

    *)
    if ! check_deployment_parameter "$2"; then
        exit 1
    fi

    # environment configuration lives within the namespace-environment specific directory
    if check_path "$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT"; then
        echo "$NAMESPACE_ENVIRONMENT exists"
    else
        echo "creating $NAMESPACE_ENVIRONMENT directory"
    fi
    
    TERRAFORM_ENV="$PWD/configuration/environments/$NAMESPACE_ENVIRONMENT/$DEPLOYMENT_NAME"
    ;;
esac
# end checks

# constants
STORAGE_ACCOUNT="sthn37mgfywa7g4"
KEY_VAULT="kv-mwt4rcwxlhxl4"
LOCATION=northeurope
# end constants

# flow
output_configuration_name "$NAMESPACE_ENVIRONMENT" "$DEPLOYMENT_NAME"

# Set values for Terraform state storage
STATE_ACCOUNT=$STORAGE_ACCOUNT
STATE_CONTAINER="$NAMESPACE_ENVIRONMENT"
STATE_FILE="$DEPLOYMENT_NAME.tfstate"

# Set environment variables for Terraform
TERRAFORM_DEPLOYMENT="$PWD/root_modules/$DEPLOYMENT_NAME"





#if check_path "$TERRAFORM_ENV"; then
#    echo "Creating directory: $NAMESPACE_ENVIRONMENT"
#    #mkdir "$TERRAFORM_ENV/$NAMESPACE_ENVIRONMENT"
#fi


# export variables
export NAMESPACE
export ENVIRONMENT
export TERRAFORM_DEPLOYMENT
export TERRAFORM_ENV

# end flow

# Testing
#echo $NAMESPACE
#echo $ENVIRONMENT



