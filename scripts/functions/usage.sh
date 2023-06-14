#!/bin/bash

function show_usage() {

    script_name=$0

    case ${script_name##*/} in

    "apply.sh")
        echo "Usage: source ./scripts/apply.sh"
        exit 1
        ;;
    "auth.sh")
        echo "Usage: source ./scripts/auth.sh"
        exit 1
        ;;
    "destroy.sh")
        echo "Usage: source ./scripts/destroy.sh"
        exit 1
        ;;
    "import.sh")
        echo "Usage: source ./scripts/import.sh terraform resource-example resource-ID example"
        echo "Usage: source ./scipts/import.sh azurerm_storage_account.example /subscriptions/0000.../resourceGroups/rg.../providers/Microsoft.Storage/storageAccounts/resource..."
        exit 1
        ;;
    "plan.sh")
        echo "Usage: source ./scripts/plan.sh"
        exit 1
        ;;
    "setup.sh")
        echo "Usage: source ./scripts/setup.sh namespace-environment root-module-name [location]"
        echo "Usage: source ./scripts/setup.sh dom-learning config"
        echo "Usage: source ./scripts/setup.sh dom-learning config westeurope"
        exit 1
        ;;
    "output.sh")
        echo "Usage: source ./scripts/output.sh - all outputs"
        echo "Usage: source ./scripts/output.sh output_name - a specific output"
        exit 1
        ;;    
    *)
        echo "script file not detected"
        echo "${script_name##*/}"
        ;;
    esac

}