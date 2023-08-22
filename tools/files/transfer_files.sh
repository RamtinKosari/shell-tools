#!/bin/bash

# Definitions
YELLOW='\033[1m\033[38;2;255;255;0m'
GRAY='\033[1m\033[38;2;230;230;230m'
CYAN='\033[0m\033[38;2;0;230;230m'
GREEN='\033[1m\033[38;2;0;255;0m'
RED='\033[1m\033[38;2;255;0;0m'
PREVIOUS_LINE="\033[F\033[K"
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

# Transfer Method (Default is Copy)
transfer_method="$3"

# Initialize
update_interval_seconds="0.5"
destination_type="file"
source_type="file"
transfer_exec=""

# Method to Transfer Files
transfer() {
    src_amount=$2
    dst_amount=$3
    transfer_exec="$1"
    echo ""
    while true; do
        current_amount=$(ls $destination | wc -l)
        transfered_amount=$(( current_amount - dst_amount ))
        echo -e "${PREVIOUS_LINE}${TAB}${LOG}Transfered : ${CYAN}$transfered_amount/$src_amount${RESET} Items"
        if [ "$transfered_amount" == "$source_amount" ]; then
            break
        # elif [ "$transfered_amount" -gt "$source_amount" ]; then
        #     echo -e "${TAB}${FAILED}Transfered Items Amount is Greater than Source Items Amount"
        #     exit 0
        fi
        sleep $update_interval_seconds
    done
}

# Check Arguments
if [ "$#" -lt 2 ]; then
    echo -e "${FAILED}Missing Arguments"
    echo -e "${TAB}${LOG}Usage : ${GRAY}rk_transfer_files ${CYAN}src dst${RESET}"
    exit 0
elif [ "$#" -gt 3 ]; then
    echo -e "${FAILED}Extra Arguments"
    echo -e "${TAB}${LOG}Usage : ${CYAN}rk_transfer_files src dst${RESET}"
    exit 0
else
    if [ "$#" -eq 3 ]; then
        if  [ "$transfer_method" == "copy" ]; then
            transfer_exec="cp"
        elif [ "$transfer_method" == "move" ]; then
            transfer_exec="mv"
        else
            echo -e "${FAILED}Invalid Argument #3"
            echo -e "${TAB}${LOG}Avalible Options : ${CYAN}copy${RESET} - ${CYAN}move${RESET}"
            exit 0
        fi
    else
        transfer_method="copy"
        transfer_exec="cp"
    fi
    # Check Type of Source
    if [ -d "$source" ]; then
        echo -e "${LOG}Source Type : ${CYAN}Directory${RESET}"
        source_type="dir"
    elif [ -e "$source" ]; then
        echo -e "${LOG}Source Type : ${CYAN}File${RESET}"
    else
        echo -e "${FAILED}Source File is Not Valid or Not Avalible"
        exit 0
    fi
    # Check Type of Destination
    if [ -d "$destination" ]; then
        echo -e "${LOG}Destination Type : ${CYAN}Directory${RESET}"
        destination_type="dir"
    elif [ -e "$destination" ]; then
        echo -e "${LOG}Destination Type : ${CYAN}File${RESET}"
    else
        echo -e "${FAILED}Destination Type is Not Valid or Not Avalible"
        exit 0
    fi
fi
# Calculate Amount of Items to be Transfered
source_items_amount=$(ls $source | wc -l)
destination_items_amount=$(ls $destination | wc -l)
# Prepare and Transfer
echo -e "${LOG}Preparing to Transfer ${CYAN}$source_items_amount${RESET}Items into ${CYAN}$destination${RESET}"
if [ "$#" -eq 2 ]; then
    echo -e "${TAB}${LOG}Transfer Method : ${CYAN}Copy${RESET}"
    echo -e "${LOG}Copying ..."
    start_time=$(date +%s)
    transfer $transfer_exec $source_items_amount $destination_items_amount
    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))
    echo -e "${SUCCESS}Copied All $source_items_amount"
else
    echo -e "${TAB}${LOG}Transfer Method : ${CYAN}Move${RESET}"
    echo -e "${LOG}Moving ..."
    start_time=$(date +%s)
    transfer $transfer_exec $source_items_amount $destination_items_amount
    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))
    echo -e "${SUCCESS}Moved All $source_items_amount"

fi
