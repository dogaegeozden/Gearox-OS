#!/bin/bash

declare_variables() {
	# A function which creates variables.

    # Creating a variable called username
    username=${SUDO_USER:-${USER}}
    # Creating a variable called_wifi_connection_info_file.
    wifi_connection_info_file="../wifi_info.txt"
    # Creating variables called SSID and PASSWD by reading the wifi_connection_info_file's lines and separating the lines with "="
    while IFS="=" read -ra INFO; do
        for i in "${INFO[@]}"; do
            SSID=${INFO[0]}
            PASSWD=${INFO[1]}
        done
    done < $wifi_connection_info_file

    sleep 2
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
    nmcli dev wifi connect $SSID password "${PASSWD}" private yes
    # Setting autoconnect no
    nmcli connection modify $SSID connection.autoconnect no
    # Waiting for 5 seconds.
    sleep 5
}

# Executing the main function.
main
