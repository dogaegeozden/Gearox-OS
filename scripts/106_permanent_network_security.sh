#!/bin/bash

declare_variables() {
	# A function which declares variables. 

	# Assing the iptables path to a variable
	path="/etc/iptables"
}

main() {
	# The function which runs the entire script.

	# Calling the declare_variables function.
	declare_variables
	# Calling the install_required_softwares function.
	install_required_softwares
}

install_required_softwares() {
	# A function which installes the required softwares.

	# Checking if netfilter-persistent software is not installed.
	if [[ `apt-cache policy "netfilter-persistent"` == *"(none)"* ]]; then
		# Installing the netfilter-persistent software.
		apt-get install netfilter-persistent -yy
	# Checking if the netfilter-persistent software is installed.
	else
		# Letting the user know that the software is already installed.
		echo "netfilter-persistent is already installed."
	fi

	# Checking if the iptables-persistent software is not installed.
	if [[ `apt-cache policy "iptables-persistent"` == *"(none)"* ]];then
		# Installing the iptables-persistent software.
		apt-get install iptables-persistent -yy
	# Checking if the iptables-persistent software is installed.
	else
		# Telling to user that the iptables-persistent software is already installed.
		echo "iptables-persistent is already installed."
	fi

	# Checking if the directory is exists.
	if [[ -d $path ]]; then
		# Saving the ipv4 policies.
		iptables-save > $path/rules.v4
		# Saving the ipv6 policies.
		ip6tables-save > $path/rules.v6
	# Checking if the directory is not exist.
	else
		# Create a new directory
		mkdir $path
		# Saving the ipv4 policies.
		iptables-save > $path/rules.v4
		# Saving the ipv6 policies.
		ip6tables-save > $path/rules.v6
	fi

	# Checking if the netfilter-persistent.service is not active..
	if [[ `systemctl status "netfilter-persistent.service"` == *"inactive (dead)"* ]]; then
		# Starting the netfilter-persistent.service.
		systemctl start netfilter-persistent.service
	# Checking if the netfilter-persistent.service is active.
	else
		# Telling to user that the netfilter-persistent service is active and running.
		echo "netfilter-persistent service is active and, working."
	fi

	# Checking if the netfilter-persistent service is not enabled.
	if [[ `systemctl status "netfilter-persistent.service"` != *"enabled"* ]]; then
		# Enabling the netfilter-persistent.service. Hint: Configuring the service as the service will going to start on computer boot.
		systemctl enable netfilter-persistent.service
	# Checking if the netfilter-persistent.service is enabled.
	else
		# Letting the user know that the service already enabled.
		echo "netfilter-persistent service is already enabled."
	fi
}

# Calling the main function.
main