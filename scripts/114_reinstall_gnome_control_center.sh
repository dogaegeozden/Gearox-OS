#!/bin/bash

main() {
    # The function which runs the entire script.

	# Calling the inform_the_user function
    inform_the_user
    # Calling the reinstall_gnome_control_center function
    reinstall_gnome_control_center

    # Printing empty lines
	echo -e "\n\n"
}

inform_the_user() {
	# A function which informs the user about what is going on 

	# Informing the user about which script is currently running
	echo  "RUNNING SCRIPT: $0" 
}

reinstall_gnome_control_center() {
    # A function which reinstalls the gnome_control_center

    # Checking if the gnome-control-center is not installed.
    if [[ `apt-cache policy "gnome-control-center"` == *"(none)"* ]]; then
        # Reinstalling the gnome-control-center
        sudo nala install --reinstall "gnome-control-center" -yy
    # Checking if the gnome-control-center is installed.
    else
        # Telling to user that the gnome-control-center is already available in the system.
        echo "gnome-control-center is already installed."
    fi
}

# Calling the main function
main