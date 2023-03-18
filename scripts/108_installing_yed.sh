#!/bin/bash


main() {
    # The function which runs the entire script.

    # Calling the inform_the_user function
    inform_the_user

    # Creating a path to the yEd setup file
    yEd_setup_file_path="../yEd_setup.sh"
    # Checking if the yEd setup file is exists in the path.
    if [[ -f yEd_setup_file_path ]]; then
         # Starting the the yEd setup file.
        bash $yEd_setup_file_path
    fi

    # Printing empty lines
	echo -e "\n\n"
}

inform_the_user() {
	# A function which informs the user about what is going on 

	# Informing the user about which script is currently running
	echo  "RUNNING SCRIPT: $0" 
}

# Calling the main function.
main