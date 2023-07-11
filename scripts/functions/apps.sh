#!/bin/bash

function output_configuration_name() {

    if command -v figlet > /dev/null 2>&1; then

        figlet -t "$1"
        echo "-----------------------------------------------------------------"
        figlet -t "$3"
        echo "-----------------------------------------------------------------"
        figlet -t "$2"

    fi

}

function check_for_terraform_executable() {

    if ! command -v terraform > /dev/null 2>&1; then
        echo "Please install Terraform"
        return 1
    fi
}

function az_logout() {

    echo -e "$(yellow)Logging out az cli$(default)"
    az logout
    sleep 5
}
