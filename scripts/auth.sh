#!/bin/bash

# shellcheck source=./scripts/functions/usage.sh
source ./scripts/functions/usage.sh

# Checks
if [ "$BASH_SOURCE" == "$0" ]; then
    show_usage
fi
# end checks

while getopts ":t:" arg; do
    case "$arg" in
    t)
        tenant=$OPTARG
        ;;
    ?)
        tenant=""
        ;;
    esac
done

if [ "$tenant" ]; then
    echo -e "\033[32mAuthenticating against tenant: $tenant \033[0m"
    if az login --tenant "$tenant" --query "sort_by([].{Name:name, Subscription:id, Tenant:tenantId},&Name)" --output table --only-show-errors; then
        tick
    else
        cross
    fi

else
    echo -e "\033[32mAuthenticating Az Cli\033[0m"
    if az login --query "sort_by([].{Name:name, Subscription:id, Tenant:tenantId},&Name)" --output table --only-show-errors; then
        tick
    else
        cross
    fi

fi

ARM_TENANT_ID=$(az account show | jq -rc '.tenantId')
export ARM_TENANT_ID

# Cleanup
unset tenant
