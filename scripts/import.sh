#!/bin/bash

# shellcheck source=./scripts/functions/usage.sh
source ./scripts/functions/usage.sh

# Checks
if [ "$BASH_SOURCE" == "$0" ]; then
    show_usage
fi

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

# Check whether the LOCATION parameter exists
if ! check_parameter "$LOCATION" "\$LOCATION"; then
    return 1
fi

# Check whether the STATE_ACCOUNT parameter exists
if ! check_parameter "$STATE_ACCOUNT" "\$STATE_ACCOUNT"; then
    return 1
fi
# end checks

# set parameters
if [[ "$NAMESPACE" == "global" ]]; then
    PARAMS="-config=$TERRAFORM_DEPLOYMENT -var="location=$LOCATION" -var="namespace=$NAMESPACE" -var="state_storage_account=$STATE_ACCOUNT" \
-var-file=$TERRAFORM_ENV/env.tfvars"
else
    PARAMS="-config=$TERRAFORM_DEPLOYMENT -var="environment=$ENVIRONMENT" -var="location=$LOCATION" -var="namespace=$NAMESPACE" -var="state_storage_account=$STATE_ACCOUNT" \
-var-file=$TERRAFORM_ENV/env.tfvars"
fi

# flow
terraform -chdir="$TERRAFORM_DEPLOYMENT" import $PARAMS $1 $2

echo -e "$(green)Done, you need to run init, plan and apply now to complete the import$(default)"
