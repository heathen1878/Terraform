#!/bin/bash

function show_usage() {
  echo "USAGE: source ./scripts/unset.sh"
  echo 
}

# script run with source ..?
if [ "$BASH_SOURCE" == "$0" ]; then
  show_usage
  exit
fi

echo "clearing $TF_ENVIRONMENT_VARS from environment variable: TF_ENVIRONMENT_VARS"
unset TF_ENVIRONMENT_VARS
echo "clearing $TF_ENVIRONMENT from environment variable: TF_ENVIRONMENT"
unset TF_ENVIRONMENT
echo "clearing $TF_MODULE from environment variable: TF_MODULE"
unset TF_MODULE
echo "clearing $TF_MODULE_CODE from environment variable: TF_MODULE_CODE"
unset TF_MODULE_CODE
