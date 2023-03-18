#!/bin/bash

 main() {
    # The function which runs the entire program.

   # Printing the script's name 
	echo -e "SCRIPT: 105_update_the_repository_info"

   # Updating the repository information
   sudo apt-get update -y

   # Printing empty lines
	echo -e "\n\n"
 }

# Calling the main function.
main