#!/bin/bash

# shellcheck source=./scripts/functions/

# dot source functions
source ./scripts/functions/common.sh
source ./scripts/functions/path.sh
source ./scripts/functions/usage.sh
source ./scripts/functions/apps.sh
source ./scripts/functions/vars.sh

# constants

# end of constants

# Checks

if ! check_for_terraform_executable; then
    return 1
fi

# check whether the TERRAFORM_ENV environment variable exists
if ! check_parameter "$TERRAFORM_ENV"; then
    return 1
fi

# Check whether the TERRAFORM_DEPLOYMENT environment variable exists
if ! check_parameter "$TERRAFORM_DEPLOYMENT"; then
    return 1
fi

# Check whether the terraform-cache exists or not
if [ ! -d "$HOME/.terraform-cache" ]; then 
    mkdir "$HOME/.terraform-cache";
fi

# cache terraform plugins so they're not repeatedly downloaded
TF_PLUGIN_CACHE_DIR="$HOME/.terraform-cache"
export TF_PLUGIN_CACHE_DIR

echo -e "$(green)Plugin cache set to : $TF_PLUGIN_CACHE_DIR$(default)"
# end of checks

# flow

# set automation parameters
AUTOMATION_PARAMS="-input=false -backend-config=$TERRAFORM_ENV/backend.tfvars -no-color -upgrade -reconfigure"
MANUAL_PARAMS="-input=false -backend-config=$TERRAFORM_ENV/backend.tfvars -upgrade -reconfigure"

terraform fmt -recursive "$TERRAFORM_DEPLOYMENT"
terraform fmt -recursive "$TERRAFORM_ENV"

if [ -n "$TF_BUILD" ]; then
    # automation mode
    terraform -chdir=$TERRAFORM_DEPLOYMENT init $AUTOMATION_PARAMS
else
    # manual mode
    terraform -chdir=$TERRAFORM_DEPLOYMENT init $MANUAL_PARAMS
fi

# end of flow