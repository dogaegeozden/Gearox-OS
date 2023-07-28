#!/bin/bash


main() {
    # The function which runs the entire script.

    # Creating a path to the yEd setup file
    yEd_setup_file_path="../yEd_setup.sh"

    # Checking if the yEd setup file is exists in the path.
    if [[ -f yEd_setup_file_path ]]; then

         # Starting the the yEd setup file.
        bash $yEd_setup_file_path

    # Checking if the yEd setup file is not exists in the path.
    else 

        # Letting the user know that the setup file could not found.
        echo "yEd setup file could not found. So, skipping it, without installing."

    # End of the if/else statement
    fi
    
}

# Calling the main function.
main