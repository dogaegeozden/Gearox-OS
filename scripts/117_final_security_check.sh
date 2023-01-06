#!/bin/bash

main() {
    # The function which runs the entire script.

    # Calling the scan_ports function
    scan_ports
}

scan_ports() {
    # A function which scan ports.

    # Creating a variable called ip_addr by getting the local ip address from the sytem.
    ip_addr=`hostname -I | awk '{print $1}'`
    # Scanning all the TCP and UDP ports 
    proxychains nmap -sT -sU -sV -sC -p- $ip_addr
}


# Calling the main function
main