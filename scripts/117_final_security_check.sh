#!/bin/bash

main() {
    # The function which runs the entire script.

    # Calling the inform_the_user function
    inform_the_user
    # Calling the scan_ports function
    scan_ports

    # Printing empty lines
	echo -e "\n\n"
}

inform_the_user() {
	# A function which informs the user about what is going on 

	# Informing the user about which script is currently running
	echo  "RUNNING SCRIPT: $0" 
}

scan_ports() {
    # A function which scan ports.

    # Creating a variable called ip_addr by getting the local ip address from the sytem.
    ip_addr=`hostname -I | awk '{print $1}'`
    # Scanning all the TCP and UDP ports 
    proxychains nmap -sT -sU -sV -sC -A -p- $ip_addr
}


# Calling the main function
main