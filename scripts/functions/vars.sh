#!/bin/bash

# shellcheck source=./scripts/functions

# dot source functions
source "./scripts/functions/common.sh"

function check_namespace_environment_parameter() {
    
    if [[ $1 != *'-'* ]]; then
        echo -e "$(red)Error: namespace-environment parameter is not in the correct format e.g. dom-learning$(default)"
        return 1
    fi

}

function check_deployment_parameter() {

    DEPLOYMENT_NAME="$(echo "$1" | awk '{print tolower($0)}')"

    if [[ ! -d $PWD/root_modules/$DEPLOYMENT_NAME ]]; then
        echo -e "$(red)Cannot find deployment directory$(default)"
        return 1
    fi

}

function check_parameter() {

    if [ -z "$1" ]; then
        echo -e "$(red)$1 is empty, please ensure ./scripts/setup.sh has been run$(default)"
        return 1
    fi

}