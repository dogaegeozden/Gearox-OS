#!/bin/bash

declare_variables() {
	# A function which creates variables.
 
    # Creating a variable called username
    username=${SUDO_USER:-${USER}}

    # Asking the wifi's SSID
    echo -n "Enter the wifi's SSID: "

    # Reading the wifi password from the user's input
    read ssid

    # Asking the wifi's password
    echo -n "Enter the wifi's password: "

    # Reading the wifi password from the user's input
    read -s internet_password

    # Printing an empty line
    echo -e "\n"

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
    echo "Connecting to $ssid"

    # Connecting to the wifi using network manager command line interface
    nmcli dev wifi connect "$ssid" password "$internet_password" private yes

    # Setting autoconnect no
    nmcli connection modify "$ssid" connection.autoconnect no

    # Waiting for 5 seconds.
    sleep 5
    
}

# Executing the main function.
main