#!/bin/bash

function check_path() {

    if [ ! -d "$1" ]; then
        echo -e "$(red)cannot find: $1$(default)"
        return 1
    else
        return 0
    fi

}
