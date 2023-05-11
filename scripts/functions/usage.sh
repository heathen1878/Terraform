#!/bin/bash

function show_usage() {

    script_name=$0

    case ${script_name##*/} in

    "setup.sh")
        echo "Usage: source ./scripts/setup.sh namespace-environment root-module-name [location]"
        echo "Usage: source ./scripts/setup.sh dom-learning config"
        echo "Usage: source ./scripts/setup.sh dom-learning config westeurope"
        exit 1
        ;;
    "auth.sh")
        echo "Usage: source ./scripts/auth.sh"
        exit 1
        ;;
    "import.sh")
        echo "Usage: ./scripts/import.sh terraform resource-example resource-ID example"
        echo "Usage: ./scipts/import.sh azurerm_storage_account.example /subscriptions/0000.../resourceGroups/rg.../providers/Microsoft.Storage/storageAccounts/resource..."
        exit 1
    ;;
    *)
        echo "script file not detected"
        echo "${script_name##*/}"
        ;;
    esac

}