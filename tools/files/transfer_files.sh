#!/bin/bash

# Definitions
CYAN='\033[0m\033[38;2;0;230;230m'
YELLOW='\033[1m\033[38;2;255;255;0m'
GRAY='\033[1m\033[38;2;230;230;230m'
GREEN='\033[1m\033[38;2;0;255;0m'
RED='\033[1m\033[38;2;255;0;0m'
RESET='\033[0m '
TAB='   '

# Log Aternatives
WARNING="${YELLOW}[WARNING]${RESET}"
SUCCESS="${GREEN}[SUCCESS]${RESET}"
FAILED="${RED}[FAILED]${RESET}"
LOG="${GRAY}[LOG]${RESET}"

# Source File or Directory
source="$1"

# Destination File or Directory
destination="$2"

# Check Arguments
if [ "$#" -lt 2 ]; then
    echo -e "${FAILED}Missing Arguments"
    echo -e "${TAB}${LOG}Usage : ${GRAY}rk_transfer_files ${CYAN}src dst${RESET}"
    exit 0
elif [ "$#" -gt 2 ]; then
    echo -e "${FAILED}Extra Arguments"
    echo -e "${TAB}${LOG}Usage : ${CYAN}rk_transfer_files src dst${RESET}"
    exit 0
else
    # Initialize Transfer Files
    source_type="file"
    destination_type="file"
    # Check Type of Source
    if [ -d "$source" ]; then
        echo -e "${LOG}Source Type : ${CYAN}Directory${RESET}"
        source_type="dir"
    else
        echo -e "${LOG}Source Type : ${CYAN}File${RESET}"
    fi
    # Check Type of Destination
    if [ -d "$destination" ]; then
        echo -e "${LOG}Destination Type : ${CYAN}Directory${RESET}"
        destination_type="dir"
    else
        echo -e "${LOG}Destination Type : ${CYAN}File${RESET}"
    fi
fi
