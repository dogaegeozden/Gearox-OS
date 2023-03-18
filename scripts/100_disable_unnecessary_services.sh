#!/bin/bash

declare_variables() {
	# A function which creates variables.

    # Creating a list of unnecessary services.
    unnecessary_services=("cups.service" "avahi-daemon.service" "avahi-daemon.socket" "cups-browsed.service" "sshd.service" "ssh.service" "exim4.service" "openvpn.service" "apache2" "httpd")
}

main () {
    # The function which runs the entire script.

    # Calling the declare_variables function.
    declare_variables
    # Calling the stop_and_disable_unnecessary_services.
    stop_and_disable_unnecessary_services
}

stop_and_disable_unnecessary_services () {
    # A function which disables all unneccsary services.

    # Loop through every single service in the list of unnecessary services.
    for service in "${unnecessary_services[@]}"; do
        # Checking if the service is not inactive.
        if [[ `systemctl status $service` != *"inactive (dead)"* ]]; then
            # Stopping the service.
            systemctl stop "$service"
        fi
        # Checking if the service is not disabled.
        if [[ `systemctl status $service` != *"disabled"* ]]; then
            # Disabling the service.
            systemctl disable "$service"
        fi
    done
}

# Executing the main function.
main