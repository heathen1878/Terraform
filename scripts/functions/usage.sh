#!/bin/bash

function show_usage() {

    script_name=$0

    case ${script_name##*/} in

    "setup.sh")
        echo "Usage: source ./scripts/setup.sh namespace-environment root-module-name"
        echo "Usage: source ./scripts/setup.sh dom-learning config"
        exit 1
        ;;
    "auth.sh")
        echo "Usage: source ./scripts/auth.sh"
        exit 1
        ;;
    *)
        echo "script file not detected"
        echo "${script_name##*/}"
        ;;
    esac

}