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

	# Calling the declare_variables function.
	declare_variables

	# Calling load_my_services function.
	load_my_services

	# Calling the load_my_startapp_applications function.
	load_my_startapp_applications

}

load_my_services() {
	# A function which sets up my services to the system.

	# Looping through each service file the list services folder.
	for service_file in `ls $services_folder_path`; do

		# Checking if the service file is not exists in the system.
		if [[ ! -f /etc/systemd/system/$service_file ]]; then

			# Copy the service file to the system.
			cp $services_folder_path$service_file "/etc/systemd/system"

			# Letting the user know that the file has been copied to /etc/systemd/system folder
			echo "$service file has been copied to /etc/systemd/system"

		fi

		# Checking if there is a link between the service file and multi-user-targer.want/$service_file.
		if [[ ! -f /etc/systemd/system/multi-user.target.wants/$service_file ]]; then

			# Creating a link between the service file and the multi-user.target.wants
			ln -s /etc/systemd/system/$service_file /etc/systemd/system/multi-user.target.wants/$service_file

			# Letting the user know that the symbolik link has been created
			echo "Symbolik link has been created"

		fi

		# Checking if the service is inactive.
		if [[ `systemctl status $service_file` == *"inactive (dead)"* ]]; then

			# Enabling the service.
			systemctl enable $service_file

		fi

		# Checking if the serviced is dead
        if [[ `systemctl status $service_file` == *"inactive (dead)"* ]]; then

			# Starting the service.
			systemctl start $service_file

		fi

	done

}

load_my_startapp_applications() {
	# A function which copys start up applications to appropriate folder to set them as they will start at boot. 
	
	# Checking if the custom start up folder is exists in the path.
	if [[ -d $my_startup_apps_folder ]]; then
		
		# Iterating over each app file in the my_startup_apps_folder path.
		for app in `ls $my_startup_apps_folder`; do

			# Checking if the file is exists.
			if [[ -f $my_startup_apps_folder$app ]]; then

				# Setting the file permissions.
				chmod 741 $my_startup_apps_folder$app
				
				# Copying the file to appropriate location.
				cp $my_startup_apps_folder$app $startup_app_folder_path
			
			# Finishing the if/else statement.
			fi
		
		# Finishing the loop.
		done
		
	# Completign the if/else statemetn.
	fi
	
}


# Calling the main function.
main