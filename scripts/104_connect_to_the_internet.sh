#!/bin/bash

declare_variables() {
	# A function which creates variables.
 
    # Creating a variable called username
    username=${SUDO_USER:-${USER}}

    # Asking the wifi's SSID
    echo "Enter the wifi's SSID: "

    # Reading the wifi password from the user's input
    read SSID

    # Asking the wifi's password
    echo "Enter the wifi's password: "

    # Reading the wifi password from the user's input
    read PASSWD

}

main() {
    # The function which runs the entire script.

    # Calling the declare_variables function.
    declare_variables

    # Calling connect_to_wifi function.
    connect_to_wifi

}

connect_to_wifi() {
    # A function which connects to the wifi.

    # Printing what application is trying to do.
    echo "Connecting to $SSID"

    # Connecting to the wifi using network manager command line interface
    nmcli dev wifi connect "$SSID" password "$PASSWD" private yes

    # Setting autoconnect no
    nmcli connection modify "$SSID" connection.autoconnect no

    # Waiting for 5 seconds.
    sleep 5
    
}

# Executing the main function.
main
