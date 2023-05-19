#!/bin/bash 

# variables
planName="$(date +%Y-%m-%d_%H-%M-%S).plan"

# checks

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
# end of checks

# flow
terraform -chdir="$TERRAFORM_DEPLOYMENT" plan -destroy \
    -refresh=true \
    -var="environment=$ENVIRONMENT" \
    -var="location=$LOCATION" \
    -var="namespace=$NAMESPACE" \
    -var="state_storage_account=$STATE_ACCOUNT" \
    -var-file="$TERRAFORM_ENV/env.tfvars" \
    -out="$TERRAFORM_ENV/plans/$planName" \
    -detailed-exitcode
    