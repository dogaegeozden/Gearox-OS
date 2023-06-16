#!/bin/bash

main(){
    # The function which runs the entire script.

    # Calling the upgrade_apt function
    upgrade_apt

    # Calling the refresh_snap function
    refresh_snap
}


upgrade_apt(){
    # A function which updates and upgrades all the packages that are installed with apt package manager
    
    # Updating and upgrading the packages that are installed with apt package manager
    sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y
}

refresh_snap(){
    # A function which updates all the snap packages

    # Updating the packages that are installed with snap package manager
    snap refresh
}

# Calling the main function.
main
