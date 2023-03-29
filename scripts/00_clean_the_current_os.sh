#!/bin/bash
# You can use the https://explainshell.com/ to understand the codes written in these scripts.

declare_variables() {
	# A function which creates variables

	# Executing the "which" system command to find the location of the apt-cache command.
	check_installation_command=`which apt-cache`
	# Creating a list of unwanted softwares.
	unnecessary_apps=("gnome-2048" "gnome-calendar" "aisleriot" "remmina" "anthy-common" "thunderbird" "fcitx" "fcitx5" "five-or-more" "four-in-a-row" "goldendict" "hitori" "gnome-nibbles" "gnome-klotski" "gnome-mines" "gnome-klotski" "gnome-mahjongg" "lightsoff" "gnome-maps" "quadrapassel" "swell-foop" "tali" "gnome-taquin" "hdate-applet" "gnome-tetravex" "xterm" "gnome-sound-recorder" "xiterm+thai" "gnome-robots" "mlterm-common" "iagno" "malcontent" "gnome-music" "gnome-terminal")
}

main() {
	# The function which runs the entire script.

	# Calling the declare_variables function
	declare_variables
	# Calling the unWantedSR function
	remove_unwanted_softwares
	# Clearing the local repository of retrieved files. It's good to run time to time to free up disk space.
	sudo apt-get clean
	# Clearing the local repository of retrieved files which are can no longer downloaded and largely useless. It's good to run time to time to free up disk space.
	sudo apt-get autoclean
}

remove_unwanted_softwares() {
	# A function which removes the unwanted softwares.

	# Looping through each software in the list of unnecessary apps.
	for app in "${unnecessary_apps[@]}"; do
		# Checking if the software is installed. Hint: If the application is installed it shouldn't include the "(none)" keyword.
 		if [[ `$check_installation_command policy "$app"` != *"(none)"* ]] || [[ `$check_installation_command policy "$app"` == *"Installed"* ]]; then
			# Purging the application.
			sudo apt purge --auto-remove "$app" -y;
            # Continuing looping after purge.
			continue
		# Checking if the software is not installed.
		else
			# Letting the user know that the software wasn't installed.
			echo "$app is not installed so, not purging."
		fi
	done
}

# Executing the main function.
main
