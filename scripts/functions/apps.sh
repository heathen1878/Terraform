#!/bin/bash

function output_configuration_name() {

    if command -v figlet > /dev/null 2>&1; then

        figlet "$1"
        echo "-----------------------------------------------------------------"
        figlet "$2"

    fi

}

function check_for_terraform_executable() {

    if ! command -v terraform > /dev/null 2>&1; then
        echo "Please install Terraform"
        return 1
    fi
}
