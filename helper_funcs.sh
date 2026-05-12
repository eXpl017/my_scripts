#!/bin/bash

# THIS FILE CONTAINS HELPER FUNCTIONS USED BY INSTALLERS/SETUP SCRIPTS

# to print a divider
function print_div {
    if [[ ! -v "${COLUMNS}" ]]; then
        width=$(tput cols)
    else
        width="${COLUMNS}"
    fi

    printf '#%.0s' $(seq 1 "${width}")
}

# to check if command is installed on the system
function is_tool_installed {
    command -v "$1" >/dev/null 2>&1
}
