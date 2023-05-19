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
# Check whether the TERRAFORM_DEPLOYMENT environment variable exists
if ! check_parameter "$TERRAFORM_DEPLOYMENT"; then
    return 1
fi
# end of checks

# flow
if [ -n "$1" ]; then
    terraform -chdir="$TERRAFORM_DEPLOYMENT" output "$1"
else
    terraform -chdir="$TERRAFORM_DEPLOYMENT" output
fi