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
	list_of_user_alias_strings=("# Electro Linux" "alias changeip='systemctl restart tor.service'" "alias torstop='systemctl stop tor.service'" "alias torstart='systemctl start tor.service'" "alias torstatus='systemctl status tor.service'")
	# Creating a list called list_of_root_alias_strings
	list_of_root_alias_strings=("# Electro Linux" "alias changeip='systemctl restart tor.service'" "alias myip='proxychains curl ifconfig.io'" "alias torstop='systemctl stop tor.service'" "alias torstart='systemctl start tor.service'" "alias torstatus='systemctl status tor.service'")
	# Creating a path which leads to ssh service's main configuration file
	sshd_config_file_path="/etc/ssh/sshd_config"
	# Creating a string which includes the fail2ban ssh local file's content
	ssh_local_file_content="[sshd]\nenabled = true\nport = ssh\nfilter = sshd\nlogpath = /var/log/auth.log\nmaxretry = 3\nbantime = 120\nignoreip = whitelist-IP" 
	# Creating a path which leads to the location where fail2ban ssh local file will be created.
	fail2ban_ssh_local_file_path="/etc/fail2ban/jail.d/sshd.conf"
	# Creating a path which leads to my swap file
	myswap_file_path="/var/opt/myswap"
	# Creating a variable called amount_of_free_swap_space_data
	amount_of_free_swap_space_data=`free -m | grep Swap:`
	# Creating a path which leads to the fstab file. Hint: fstab file is the file where you define the file systems that will be mount automatically.
	fstab_file_path="/etc/fstab"
}

main() {
	# The function which runs the entire script.

	# Printing the script's name 
	echo -e "SCRIPT: 110_apply_configuration"

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
	# Calling the configure_ssh function.
	configure_ssh
	# Calling the set_up_the_fail2ban function.
	set_up_the_fail2ban
	# Calling the set_up_the_clamav function.
	set_up_the_clamav
	# Calling the set_up_the_vnstat function.
	set_up_the_vnstat
	# Calling the enable_swap_file function.
	enable_swap_file

	# Printing empty lines
	echo -e "\n\n"
}


change_the_default_terminal_emulator() {
	# A function which configures the proxychains software.

	# Changing the default terminal emulator from gnome-terminal to tilix
	sudo update-alternatives --set x-terminal-emulator /usr/bin/tilix.wrapper
}

configure_the_proxychains() {
	#  A function which configures the proxychains software.

	# Checking if the replace0 variable is not already in the proxychains configuration file.
	if [[ ! `grep $replace0 $proxychain_conf_file` ]]; then
		# Replace the search variable with replace variable in the idenfied file
		sed -i "s/$search0/$replace0/" $proxychain_conf_file
	fi
	# Replace the search variable with replace variable in the idenfied file
	sed -i "s/$search1/$replace1/" $proxychain_conf_file
	# Replace the search variable with replace variable in the idenfied file
	sed -i "s/$search2/$replace2/" $proxychain_conf_file

	# Restarting the tor service to apply the changes
	systemctl restart tor.service
}

create_the_user_aliases() {
	# A function which creates aliases for the regular user. 

	# Looping through each alias in the list_of_user_alias_strings.
	for alias in "${list_of_user_alias_strings[@]}"; do
		# Checking if the alias is already created in the user's .bashrc file.
		if [[ ! `grep "$alias" "/home/$username/.bashrc"` ]]; then
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
		if [[ ! `grep "$alias" "/root/.bashrc"` ]]; then
			echo "$alias" >> "/root/.bashrc"
		fi
	done

	# Executing commands from a file in the current shell
	source /root/.bashrc
}

configure_ssh() {
	# A function which configures the ssh 
	
	# Setting PermitRootLogin to no if it's yes
	if [[ `grep "PermitRootLogin yes" "$sshd_config_file_path"` ]]; then 
		sed -i "s/PermitRootLogin yes/PermitRootLogin no/" "$sshd_config_file_path"
	fi
	# Setting PasswordAuthentication to no if it's yes
	if [[ `grep "PasswordAuthentication yes" "$sshd_config_file_path"` ]]; then 
		sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/" "$sshd_config_file_path"
	fi
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

	# Creating a local file to configure fail2ban for ssh
	echo -e $ssh_local_file_content > $fail2ban_ssh_local_file_path

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

set_up_the_clamav() {
	# A function which sets up the clamav. Hint: clamav is an open source text based anti-virus software.
	# Hint: You can scan your file system for viruses using clamav -irv /path/to/folder

	# Updating a database for plocate
	updatedb

	# Checking if the clamav-freshclam service is running. Hint: Freshclam is a service which updates the virus database.
	if [[ `systemctl status clamav-freshclam` != *"inactive (dead)"* ]]; then
		# Stopping the clamav-freshclam service
		service clamav-freshclam stop	
	fi
	
	# Updating the virus databases
	freshclam

	# Checking if the clamav-freshclam service is dead
	if [[ `systemctl status clamav-freshclam` == *"inactive (dead)"* ]]; then
		# Stopping the clamav-freshclam service
		service clamav-freshclam start	
	fi

}

enable_swap_file () {
	# A function which enables the swap area. Hint: Swap area is a type of file system which holds data when RAM is used up. It's preventing app crashes

	# Checking if myswap file is not exists
	if [[ ! -f "$myswap_file_path" ]]; then
		# Creating a swap file
		dd if="/dev/zero" of="$myswap_file_path" bs=1M count=16384
		# Setting up the linux swap area
		mkswap "$myswap_file_path"
		# Enabling the swap 
		swapon "$myswap_file_path"
		# Checking if the fstab file doesn't include the swap file specification string
		if [[ ! `grep "$myswap_file_path swap swap defaults 0 0" $fstab_file_path` ]]; then
			# Make the swap area permanent
			echo "$myswap_file_path swap swap defaults 0 0" >> $fstab_file_path
		fi

	# Checking if myswap file is exists
	else
		# Creating an array called strarr by splitting the command's output with IFS delimiter.
		IFS=' ' read -a strarr <<< "$amount_of_free_swap_space_data"
		# Identifying the total swap size
		swap_size="${strarr[1]}"
		# Checking if total swap size is smaller than  10000 mega bytes 
		if [[ $swap_size < 10000 ]]; then 
			# Deleting the swap file
			rm "$myswap_file_path"
			# Creating a new swap file
			dd if="/dev/zero" of="$myswap_file_path" bs=1M count=16384
			# Setting up the linux swap area
			mkswap "$myswap_file_path"
			# Enabling the swap 
			swapon "$myswap_file_path"
			# Checking if file file specification is not already specified in the "/etc/fstab file"
			if [[ ! `grep "$myswap_file_path swap swap defaults 0 0" $fstab_file_path` ]]; then
				# Make the swap area permanent
				echo "$myswap_file_path swap swap defaults 0 0" >> $fstab_file_path
			fi
		fi
	fi
}

# Calling the main function.
main
