#!/bin/bash

main(){
    # The function which runs the entire script.

    # Upgrading the operating system.
    sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y
}

# Calling the main function.
main