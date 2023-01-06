#!/bin/bash

declare_variables() {
	# A function which declares variables.

	# Creating a variable called username which hold's the user's username.
	username=${SUDO_USER:-${USER}}
	# Capturing the wifi adaptor name
	for dev in `ls /sys/class/net` ; do [ -d "/sys/class/net/$dev/wireless" ] && wifi_adaptor_name="$dev" ; done
	# Creating a path which leads to the proxychains.conf file.
	proxychain_conf_file="/etc/proxychains.conf"
	# Creating the first variables which will be search in the proxychains.conf file and will be replaced.
	search0="strict_chain"
	replace0="#strict_chain"
	# Creating the second variables which will be search in the proxychains.conf file and will be replaced.
	search1="#dynamic_chain"
	replace1="dynamic_chain"
	# Creating the third variables which will be search in the proxychains.conf file and will be replaced.
	search2="socks4 	127.0.0.1 9050"
	replace2="socks5 	127.0.0.1 9050"
	# Creating a list called list_of_user_alias_strings.
	list_of_user_alias_strings=("#Gearox Home Aliases" "alias changeip='systemctl restart tor.service'" "alias torstop='systemctl stop tor.service'" "alias torstart='systemctl start tor.service'" "alias torstatus='systemctl status tor.service'" "alias androidstudio='bash /home/$userName/Downloads/android-studio/bin/studio.sh'")
	# Creating a list called list_of_root_alias_strings
	list_of_root_alias_strings=("#Gearox Home Aliases" "alias changeip='systemctl restart tor.service'" "alias myip='proxychains curl ifconfig.io'" "alias torstop='systemctl stop tor.service'" "alias torstart='systemctl start tor.service'" "alias torstatus='systemctl status tor.service'")
}

main() {
	# The function which runs the entire script.

	# Calling the declare_variables function.
	declare_variables
	# Calling the change_the_default_terminal_emulator function.
	change_the_default_terminal_emulator
	# Calling the configure_the_proxychains function.
	configure_the_proxychains
	# Calling the create_the_user_aliases function.
	create_the_user_aliases
	# Calling the create_the_root_aliases function.
	create_the_root_aliases
	# Calling the set_up_the_fail2ban function.
	set_up_the_fail2ban
	# Calling the set_up_the_vnstat function.
	set_up_the_vnstat
}


change_the_default_terminal_emulator() {
	# A function which configures the proxychains software.

	# Changing the default terminal emulator from gnome-terminal to tilix
	sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix.wrapper
}

configure_the_proxychains() {
	#  A function which configures the proxychains software.

	# Replace the search variable with replace variable in the idenfied file
	if [[ $search0 != "" && $replace0 != "" ]]; then
		sed -i "s/$search0/$replace0/" $proxychain_conf_file
	fi

	# Replace the search variable with replace variable in the idenfied file
	if [[ $search1 != "" && $replace1 != "" ]]; then
		sed -i "s/$search1/$replace1/" $proxychain_conf_file
	fi

	# Replace the search variable with replace variable in the idenfied file
	if [[ $search2 != "" && $replace2 != "" ]]; then
		sed -i "s/$search2/$replace2/" $proxychain_conf_file
	fi

	# Restarting the tor service to apply the changes
	systemctl restart tor.service
}

create_the_user_aliases() {
	# A function which creates aliases for the regular user. 

	# Looping through each alias in the list_of_user_alias_strings.
	for alias in "${list_of_user_alias_strings[@]}"; do
		# Checking if the alias is already created in the user's .bashrc file.
		if [[ ! `grep -q "$alias" "/home/$username/.bashrc"` ]]; then
			# Appending alias to the end of the user's .bashrc file.
			echo "$alias" >> "/home/$username/.bashrc"
		fi
	done
	
	# Executing commands from a file in the current shell
	source /home/$username/.bashrc
}

create_the_root_aliases() {
	# A function which creates aliases for the root user. 

	# Looping through each alias in the list_of_root_alias_strings.
	for alias in "${list_of_root_alias_strings[@]}"; do
		if [[ ! `grep -q "$alias" "/root/.bashrc"` ]]; then
			echo "$alias" >> "/root/.bashrc"
		fi
	done

	# Executing commands from a file in the current shell
	source /root/.bashrc
}

set_up_the_fail2ban() {
	# A function which sets up the fail2ban software.

	# Checking if the fail2ban service is not installed in the system.
	if [[ `apt cache policy fail2ban` == *"(none)"* ]]; then
		nala install fail2ban -y;
	# Checking if fail2ban is installed on the system.
	else
		echo "fail2ban is alread instaled in your system."
	fi
	# Checking if the service is dead
	if [[ `systemctl status fail2ban` == *"inactive (dead)"* ]]; then
		# Starting the service
		systemctl start fail2ban.service
	# Checking if the service is not dead.
	else
		# Letting the user know that the service active and running.
		echo "fail2ban service is already active and running"
	fi
	# Checking if the service is not enabled. Hint: If a service is enabled that means it's going to be started on every boot.
	if [[ `systemctl status "fail2ban.service"` != *"enabled"* ]]; then
		# Enabling the service.
		systemctl enable fail2ban.service
	# Checking if the service is enabled.
	else
		# Letting the user know that the service is already enabled.
		echo "fail2ban service is already enabled."
	fi
}

set_up_the_vnstat() {
	# A function which sets up the vnstat. Hint: vnstat is a perfect network traffic monitor. You can watch your internet traffic live.

	# Configuring the vnstat
	vnstat -i $wifi_adaptor_name
	# Initializing the database
	vnstat
}

# Calling the main function.
main