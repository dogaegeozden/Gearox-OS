#!/bin/bash

declare_variables() {
	# A function which declares variables.

	# Creating a variable called username
	username=${SUDO_USER:-${USER}}
	# Creating a path which leads to the command_line_tools folder.
	command_line_tools_folder_path="../command_line_tools/"
	# Creating a path which leads to the services folder.
	services_folder_path="../services/"
	# Creating a path to the folder where the startup applications are located on debian based operating system.
	startup_app_folder_path="~/.config/autostart/"
	# Creating a path which leads to the start_up_applications folder.
	my_startup_apps_folder="../startup_applications/"
}

main() {
	# The function which runs the entire script.

	# Printing the script's name 
	echo -e "SCRIPT: 109_add_services"

	# Calling the declare_variables function.
	declare_variables
	# Calling load_my_services function.
	load_my_services
	# Calling the load_my_startapp_applications function.
	load_my_startapp_applications

	# Printing empty lines
	echo -e "\n\n"
}


load_my_services() {
	# A function which sets up my services to the system.

	# Looping through each service file the list services folder.
	for service_file in `ls $services_folder_path`; do
		# Checking if the service file is not exists in the system.
		if [[ ! -f /etc/systemd/system/$service_file ]]; then
			# Copy the service file to the system.
			cp $services_folder_path$service_file "/etc/systemd/system"
		fi
		# Checking if there is a link between the service file and multi-user-targer.want/$service_file.
		if [[ ! -f /etc/systemd/system/multi-user.target.wants/$service_file ]]; then
			# Creating a link between the service file and the multi-user.target.wants
			ln -s /etc/systemd/system/$service_file /etc/systemd/system/multi-user.target.wants/$service_file
		fi
		# Checking if the service is inactive.
		if [[ `systemctl status $service_file` == *"inactive (dead)"* ]]; then
			# Enabling the service.
			systemctl enable $service_file
		fi

        if [[ `systemctl status $service_file` == *"inactive (dead)"* ]]; then
			# Starting the service.
			systemctl start $service_file
		fi
	done
}

load_my_startapp_applications() {
	if [[ -d $my_startup_apps_folder ]]; then
		for app in `ls $my_startup_apps_folder`; do
			if [[ -f $my_startup_apps_folder$app ]]; then
				chmod 741 $my_startup_apps_folder$app
				cp $my_startup_apps_folder$app $startup_app_folder_path
			fi
		done
	fi
}

# Calling the main function.
main