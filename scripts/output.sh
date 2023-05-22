#!/bin/bash

# shellcheck source=./scripts/functions/usage.sh
source ./scripts/functions/usage.sh

# Checks
if [ "$BASH_SOURCE" == "$0" ]; then
    show_usage
fi

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