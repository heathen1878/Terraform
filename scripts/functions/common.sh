#!/bin/bash

function green() {

    echo -e "\033[1;32m"

}

function default() {

    echo -e "\033[0m"

}

function red() {

    echo -e "\033[1;31m"

}

function magenta() {

    echo -e "\033[1;35m"

}

function tick() {

    echo -e "\033[32m✔"

}

function cross() {
    
    echo -e "\033[31m✘"

}

function warning() {

    echo -e "\033[33m‼"

}