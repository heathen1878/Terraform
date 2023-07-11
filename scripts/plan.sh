#!/bin/bash 

# shellcheck source=./scripts/functions/usage.sh
source ./scripts/functions/usage.sh

# variables
planName="$(date +%Y-%m-%d_%H-%M-%S).plan"

# checks
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
# end of checks

# set parameters
if [[ "$NAMESPACE" == "global" ]]; then
    PARAMS="-refresh=true -var-file="$TERRAFORM_ENV/env.tfvars" -out="$TERRAFORM_ENV/plans/$planName" -detailed-exitcode"
else
    PARAMS="-refresh=true -var-file="$TERRAFORM_ENV/env.tfvars" -out="$TERRAFORM_ENV/plans/$planName" -detailed-exitcode"
fi

# flow
terraform -chdir="$TERRAFORM_DEPLOYMENT" plan $PARAMS
EXITCODE=$?

export EXITCODE

#In DevOps the exit code is handled in the yaml pipeline.
if [ -z "$TF_BUILD" ]; then
    # Running in a DevOps pipeline
    case $EXITCODE in
        0)
            return 0
        ;;
        1)
            echo "Error planning"
            return 1
        ;;
        2)
            return 0
        ;;
    esac
fi