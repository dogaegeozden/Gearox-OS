#!/bin/bash

declaring_variables() {
    # A function which declares variables.

    # Creating a variable called username, by getting the user's username from the system. 
    username=${SUDO_USER:-${USER}}
    # Declare an array variable for kde unwanted kde applications
    auto_installed_unwanted_apps=("kdeconnect" "kde5")
    # Creating a path which leads to the location where apt-cache command is available by executing the "which" system command.
    check_installation_command=`which apt-cache`
}

main() {
    # The function which runs the entire script.

    # Calling the declaring_variables function.
    declaring_variables
    # Calling the remove_auto_installed_unwanted_sofwares function.
    remove_auto_installed_unwanted_sofwares
}

remove_auto_installed_unwanted_sofwares() {
    # A function which removes the softwares that auto installed unwanted.

    # Looping through each app in the auto_installed_unwanted_apps list.
    for app in "${auto_installed_unwanted_apps[@]}"; do
        # Checking if the application is installed.
        if [[ `$check_installation_command policy "$app"` != *"(none)"* ]]; then
            sudo nala purge --auto-remove "$app" -yy
            continue
        # Checking if the favorite app is intalled.
        else
            # Letting the user know that the software is already available in the system.
            echo "$app is not installed so, not purging."
        fi
    done
}

# Calling the main function.
main