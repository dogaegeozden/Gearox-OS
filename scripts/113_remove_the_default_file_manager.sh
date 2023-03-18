#!/bin/bash

main(){
    # The function which runs the entire script.

    # Printing the script's name 
	echo -e "SCRIPT: 113_remove_the_default_file_manager"

    # Calling the purge_the_default_file_manager function.
    purge_the_default_file_manager

    # Printing empty lines
	echo -e "\n\n"
}

purge_the_default_file_manager() {
    # A function which purges the default file system.

    # Checking if the nautilus software is installed.
    if [[ `apt-cache policy "nautilus"` != *"(none)"* ]]; then
        # Purging the nautilus file manager
        sudo apt purge --auto-remove "nautilus" -y
    # Checking if the nautilus file manager is not installed.
    else
        # Letting the user know that the nautilus file manager is not installed in the system.
        echo "Nautilus file manager isn't available in the system."
    fi
}

# Calling the main function.
main
