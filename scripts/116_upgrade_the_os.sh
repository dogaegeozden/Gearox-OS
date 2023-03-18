#!/bin/bash

main(){
    # The function which runs the entire script.

    # Printing the script's name 
	echo -e "SCRIPT: 116_upgrade_the_os"

    # Upgrading the operating system.
    sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y

    # Printing empty lines
	echo -e "\n\n"
}

# Calling the main function.
main