#!/bin/bash

# Checks
# check script for input parameters
if (( $# == 0 )); then
    show_usage
fi

# Check whether the TERRAFORM_ENV environment variable exists
if ! check_parameter "$TERRAFORM_ENV"; then
    return 1
fi

# Check whether the TERRAFORM_DEPLOYMENT environment variable exists
if ! check_parameter "$TERRAFORM_DEPLOYMENT"; then
    return 1
fi

# Check whether the ENVIRONMENT parameter exists
if ! check_parameter "$ENVIRONMENT"; then
    return 1
fi

# Check whether the NAMESPACE parameter exists
if ! check_parameter "$NAMESPACE"; then
    return 1
fi

# Check whether the LOCATION parameter exists
if ! check_parameter "$LOCATION"; then
    return 1
fi

# Check whether the STATE_ACCOUNT parameter exists
if ! check_parameter "$STATE_ACCOUNT"; then
    return 1
fi
# end checks

# flow
terraform -chdir="$TERRAFORM_DEPLOYMENT" import \
    -config="$TERRAFORM_DEPLOYMENT" \
    -var="environment=$ENVIRONMENT" \
    -var="location=$LOCATION" \
    -var="namespace=$NAMESPACE" \
    -var="state_storage_account=$STATE_ACCOUNT" \
    -var-file="$TERRAFORM_ENV/env.tfvars" \
    $1 \
    $2

echo -e "$(green)Done, you need to run init, plan and apply now to complete the import$(default)"
