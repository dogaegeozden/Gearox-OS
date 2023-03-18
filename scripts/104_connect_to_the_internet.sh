#!/bin/bash

declare_variables() {
	# A function which creates variables.
 
    # Creating a variable called username
    username=${SUDO_USER:-${USER}}
    # Creating a variable called_wifi_connection_info_file.
    wifi_connection_info_file=`cat ../wifi_info.txt`    
    # Asking the wifi's SSID
    echo "Enter your wifi SSID: "
    # Reading the wifi password from the user's input
    read SSID
    # Asking the wifi's password
    echo "Enter your wifi password: "
    # Reading the wifi password from the user's input
    read PASSWD
}

main() {
    # The function which runs the entire script.

    # Printing the script's name 
	echo -e "SCRIPT: 104_connect_to_the_internet"

    # Calling the declare_variables function.
    declare_variables
    # Calling connect_to_wifi function.
    connect_to_wifi

    # Printing empty lines
	echo -e "\n\n"
}

connect_to_wifi() {
    # A function which connects to the wifi.

    # Printing what application is trying to do.
    echo "Connecting to $SSID"

    # Connecting to the wifi using network manager command line interface
    nmcli dev wifi connect $SSID password "$PASSWD" private yes
    # Setting autoconnect no
    nmcli connection modify $SSID connection.autoconnect no
    # Waiting for 5 seconds.
    sleep 5
}

# Executing the main function.
main
