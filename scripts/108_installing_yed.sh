#!/bin/bash


main() {
    # The function which runs the entire script.

    # Printing the script's name 
	echo -e "SCRIPT: 108_installing_yed"

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

# Calling the main function.
main