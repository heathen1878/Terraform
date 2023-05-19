#!/bin/bash 

# variables
planName="$(date +%Y-%m-%d_%H-%M-%S).plan"

# checks

# Check whether the TERRAFORM_ENV environment variable exists
if ! check_parameter "$TERRAFORM_ENV" "\$TERRAFORM_ENV"; then
    return 1
fi

# Check whether the TERRAFORM_DEPLOYMENT environment variable exists
if ! check_parameter "$TERRAFORM_DEPLOYMENT" "\$TERRAFORM_DEPLOYMENT"; then
    return 1
fi

# Check whether the ENVIRONMENT parameter exists
if [[ "$NAMESPACE" != "global" ]]; then
    if ! check_parameter "$ENVIRONMENT" "\$ENVIRONMENT"; then
        return 1
    fi
fi

# Check whether the NAMESPACE parameter exists
if ! check_parameter "$NAMESPACE" "\$NAMESPACE"; then
    return 1
fi
# end of checks

# set parameters
if [[ "$NAMESPACE" == "global" ]]; then
    PARAMS="-refresh=true -var="location=$LOCATION" -var="namespace=$NAMESPACE" -var="state_storage_account=$STATE_ACCOUNT" \
-var-file="$TERRAFORM_ENV/env.tfvars" -out="$TERRAFORM_ENV/plans/$planName" -detailed-exitcode"
else
    PARAMS="-refresh=true -var="environment=$ENVIRONMENT" -var="location=$LOCATION" -var="namespace=$NAMESPACE" -var="state_storage_account=$STATE_ACCOUNT" \
-var-file="$TERRAFORM_ENV/env.tfvars" -out="$TERRAFORM_ENV/plans/$planName" -detailed-exitcode"
fi

# flow
terraform -chdir="$TERRAFORM_DEPLOYMENT" plan $PARAMS    
    