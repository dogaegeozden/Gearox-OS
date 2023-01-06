#!/bin/bash


main() {
    # The function which runs the entire script.

    # Creating a path to the yEd setup file
    yEd_setup_file_path="../yEd_setup.sh"
    # Checking if the yEd setup file is exists in the path.
    if [[ -f yEd_setup_file_path ]] {
         # Starting the the yEd setup file.
        bash $yEd_setup_file_path
    }
}

# Calling the main function.
main