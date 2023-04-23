#!/bin/bash

function check_namespace_environment_parameter() {
    
    if [[ $1 != *'-'* ]]; then
        echo "Error: namespace-environment parameter is not in the correct format e.g. dom-learning"
        return 1
    fi

}

function check_deployment_parameter() {

    DEPLOYMENT_NAME="$(echo "$1" | awk '{print tolower($0)}')"

    if [[ ! -d $PWD/root_modules/$DEPLOYMENT_NAME ]]; then
        echo "Cannot find deployment directory"
        return 1
    fi

}