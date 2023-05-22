#!/bin/bash

# shellcheck source=./scripts/functions/usage.sh
source ./scripts/functions/usage.sh

# checks
if [ "$BASH_SOURCE" == "$0" ]; then
    show_usage
fi

if ! check_for_terraform_executable; then
    return 1
fi

# check whether the TERRAFORM_ENV environment variable exists
if ! check_parameter "$TERRAFORM_ENV" "\$TERRAFORM_ENV"; then
    return 1
fi

# Check whether the TERRAFORM_DEPLOYMENT environment variable exists
if ! check_parameter "$TERRAFORM_DEPLOYMENT" "\$TERRAFORM_DEPLOYMENT"; then
    return 1
fi
# end checks

# variables
AUTOMATION_PARAMS="-input=false"
MANUAL_PARAMS="-input=false"
filePlan=$(find "$TERRAFORM_ENV"/plans/*.plan -type f | sort -rn | head -1)

# flow
echo -e "$(green)Applying latest plan: $filePlan$(default)"

if [ -n "$TF_BUILD" ]; then
    # automation mode
    if ! (terraform -chdir="$TERRAFORM_DEPLOYMENT" apply $AUTOMATION_PARAMS "$filePlan"); then
        return 1
    fi
else
    # manual mode
    if ! (terraform -chdir="$TERRAFORM_DEPLOYMENT" apply $MANUAL_PARAMS "$filePlan"); then
        return 1
    fi  
fi

# end of flow
